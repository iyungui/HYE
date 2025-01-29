//
//  CloudKitManager.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import CloudKit
import UIKit

@MainActor
class CloudKitManager: ObservableObject {
    private let database = CKContainer.default().publicCloudDatabase
    @Published var images: [UIImage] = []
    @Published var isLoading = false

    private let cache = NSCache<NSString, UIImage>()
    
    // 캐시 설정
    init() {
        cache.countLimit = 100  // 최대 캐시 이미지 수
        cache.totalCostLimit = 1024 * 1024 * 100  // 100MB 제한
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(false)
            return
        }
        
        let imageURL = saveToTemporaryDirectory(data: imageData)
        
        let record = CKRecord(recordType: "UserPhoto")
        record["photo"] = CKAsset(fileURL: imageURL)
        record["uploadDate"] = Date()

        database.save(record) { [weak self] savedRecord, error in
            if let error = error {
                print("Error saving new image: \(error.localizedDescription)")
                completion(false)
            } else {
                // 메인 액터에서 fetchImages 호출
                Task { @MainActor in
                    await self?.fetchImages()
                    completion(true)
                }
            }
        }
    }
    
    private func saveToTemporaryDirectory(data: Data) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image to temporary directory: \(error.localizedDescription)")
        }
        return fileURL
    }

    func fetchImages() async {
        isLoading = true
        defer { isLoading = false }
        
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        do {
            let (matchResults, _) = try await database.records(matching: query)
            let newImages = await withTaskGroup(of: UIImage?.self) { group in
                for result in matchResults {
                    group.addTask {
                        if let record = try? result.1.get(),
                           let asset = record["photo"] as? CKAsset,
                           let fileURL = asset.fileURL,
                           let data = try? Data(contentsOf: fileURL),
                           let image = UIImage(data: data) {
                            return image
                        }
                        return nil
                    }
                }
                
                var images: [UIImage] = []
                for await image in group {
                    if let image = image {
                        images.append(image)
                    }
                }
                return images
            }
            
            await MainActor.run {
                self.images = newImages
            }
        } catch {
            print("Error fetching images: \(error.localizedDescription)")
        }
    }

    func fetchRandomImage() async throws -> UIImage? {
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        
        do {
            let (matchResults, _) = try await database.records(matching: query)
            let records = matchResults.compactMap { try? $0.1.get() }
            
            guard let randomRecord = records.randomElement() else { return nil }
            
            // 캐시된 이미지가 있는지 확인
            let recordID = randomRecord.recordID.recordName as NSString
            if let cachedImage = cache.object(forKey: recordID) {
                return cachedImage
            }
            
            // 새로운 이미지 로드
            if let asset = randomRecord["photo"] as? CKAsset,
               let fileURL = asset.fileURL,
               let data = try? Data(contentsOf: fileURL),
               let image = UIImage(data: data) {
                // 캐시에 저장
                cache.setObject(image, forKey: randomRecord.recordID.recordName as NSString)
                return image
            }
            
            return nil
        } catch {
            throw error
        }
    }

    
    // MARK: - APNS
//    func subscribeToNewPhotos() {
//        // 1. 기존 구독 확인 및 삭제
//        database.fetchAllSubscriptions { [weak self] subscriptions, error in
//            guard let self = self else { return }
//            
//            // 기존 구독이 있다면 삭제
//            if let subscriptions = subscriptions {
//                for subscription in subscriptions {
//                    self.database.delete(withSubscriptionID: subscription.subscriptionID) { _, error in
//                        if let error = error {
//                            print("기존 구독 삭제 실패: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//            
//            // 2. 새로운 구독 생성
//            let predicate = NSPredicate(value: true)
//            let subscription = CKQuerySubscription(
//                recordType: "UserPhoto",
//                predicate: predicate,
//                subscriptionID: "newPhotosSubscription",
//                options: [.firesOnRecordCreation]
//            )
//            
//            // 3. 알림 정보 설정
//            let notificationInfo = CKSubscription.NotificationInfo()
//            notificationInfo.alertBody = "새로운 사진이 추가되었습니다!"
//            notificationInfo.shouldBadge = true
//            notificationInfo.shouldSendContentAvailable = true  // silent push를 위한 설정
//            notificationInfo.category = "NEW_PHOTO"  // 알림 카테고리 설정
//            notificationInfo.soundName = "default"
//            
//            subscription.notificationInfo = notificationInfo
//            
//            // 4. 구독 저장
//            self.database.save(subscription) { savedSubscription, error in
//                if let error = error {
//                    print("Push notification 구독 저장 실패: \(error.localizedDescription)")
//                } else {
//                    print("Push notification 구독 성공")
//                }
//            }
//        }
//    }
}
