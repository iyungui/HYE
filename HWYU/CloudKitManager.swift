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
    private let container = CKContainer.default()
    private let database = CKContainer.default().publicCloudDatabase
    @Published var images: [UIImage] = []
    @Published var isLoading = false
    @Published var subscriptionActive = false

    private let cache = NSCache<NSString, UIImage>()
    private let imageProcessingQueue = DispatchQueue(label: "com.app.imageprocessing", qos: .userInitiated, attributes: .concurrent)
    
    // 캐시 설정
    init() {
        cache.countLimit = 100  // 최대 캐시 이미지 수
        cache.totalCostLimit = 1024 * 1024 * 100  // 100MB 제한
        
        // 앱 시작 시 구독 상태 확인
        Task {
            await checkSubscriptionStatus()
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (Bool) -> Void) {
        // 업로드 전 이미지 최적화
        imageProcessingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // 이미지 크기 체크 (너무 크면 리사이징)
            let maxDimension: CGFloat = 1200
            var finalImage = image
            
            if image.size.width > maxDimension || image.size.height > maxDimension {
                let scale = maxDimension / max(image.size.width, image.size.height)
                let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                image.draw(in: CGRect(origin: .zero, size: newSize))
                if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                    finalImage = resizedImage
                }
                UIGraphicsEndImageContext()
            }
            
            let compressionQuality: CGFloat = finalImage.jpegData(compressionQuality: 0.8)?.count ?? 0 > 1024 * 1024 ? 0.3 : 0.5
            
            guard let imageData = finalImage.jpegData(compressionQuality: compressionQuality) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let imageURL = self.saveToTemporaryDirectory(data: imageData)
            
            let record = CKRecord(recordType: "UserPhoto")
            record["photo"] = CKAsset(fileURL: imageURL)
            record["uploadDate"] = Date()
            
            // 메인 스레드로 전환하여 CloudKit 작업 수행
            DispatchQueue.main.async {
                self.database.save(record) { [weak self] savedRecord, error in
                    if let error = error {
                        print("Error saving new image: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        // 저장한 이미지를 캐시에 추가
                        if let recordID = savedRecord?.recordID.recordName {
                            self?.cache.setObject(finalImage, forKey: recordID as NSString)
                        }
                        
                        // 메인 액터에서 fetchImages 호출
                        Task { @MainActor in
                            await self?.fetchImages()
                            completion(true)
                        }
                    }
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
        
        // 최근 20개의 이미지만 가져오도록 쿼리 최적화
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 20  // 이미지 수 제한
        
        do {
            let (matchResults, _) = try await database.records(matching: query, resultsLimit: 20)
            let newImages = await withTaskGroup(of: (String, UIImage?).self) { group in
                for result in matchResults {
                    group.addTask {
                        do {
                            let record = try result.1.get()
                            let recordID = record.recordID.recordName
                            
                            // 캐시에서 먼저 확인
                            if let cachedImage = self.cache.object(forKey: recordID as NSString) {
                                return (recordID, cachedImage)
                            }
                            
                            // 캐시에 없으면 로드
                            if let asset = record["photo"] as? CKAsset,
                               let fileURL = asset.fileURL,
                               let data = try? Data(contentsOf: fileURL),
                               let image = UIImage(data: data) {
                                // 캐시에 저장
                                self.cache.setObject(image, forKey: recordID as NSString)
                                return (recordID, image)
                            }
                            return (recordID, nil)
                        } catch {
                            print("Error processing record: \(error.localizedDescription)")
                            return ("", nil)
                        }
                    }
                }
                
                var images: [UIImage] = []
                for await (_, image) in group {
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
        // 로딩 최적화: 최근 10개 이미지에서만 랜덤 선택
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        do {
            let (matchResults, _) = try await database.records(matching: query, resultsLimit: 10)
            let records = matchResults.compactMap { try? $0.1.get() }
            
            guard let randomRecord = records.randomElement() else { return nil }
            
            // 캐시된 이미지가 있는지 확인
            let recordID = randomRecord.recordID.recordName as NSString
            if let cachedImage = cache.object(forKey: recordID) {
                print("캐시된 이미지 사용")
                return cachedImage
            }
            
            // 새로운 이미지 로드 - 비동기로 처리
            if let asset = randomRecord["photo"] as? CKAsset,
               let fileURL = asset.fileURL {
                
                // 이미지 로딩을 별도 스레드에서 처리
                return try await withCheckedThrowingContinuation { continuation in
                    imageProcessingQueue.async {
                        do {
                            let data = try Data(contentsOf: fileURL)
                            
                            if let image = UIImage(data: data) {
                                // 다운샘플링 적용 (필요한 경우)
                                let finalImage = self.downsampleImageIfNeeded(image: image)
                                
                                // 캐시에 저장
                                self.cache.setObject(finalImage, forKey: recordID)
                                
                                // 결과 반환
                                continuation.resume(returning: finalImage)
                            } else {
                                continuation.resume(returning: nil)
                            }
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
            
            return nil
        } catch {
            throw error
        }
    }
    
    // 큰 이미지 다운샘플링 처리
    private func downsampleImageIfNeeded(image: UIImage) -> UIImage {
        let maxDimension: CGFloat = 1200
        
        // 이미지가 기준 크기보다 작으면 그대로 반환
        if image.size.width <= maxDimension && image.size.height <= maxDimension {
            return image
        }
        
        // 리사이징 필요
        let scale = maxDimension / max(image.size.width, image.size.height)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    // MARK: - APNS
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한 획득 성공")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 구독 상태 확인
    func checkSubscriptionStatus() async {
        do {
            let subscriptions = try await database.allSubscriptions()
            let hasSubscription = subscriptions.contains { $0.subscriptionID == "newPhotosSubscription" }
            await MainActor.run {
                self.subscriptionActive = hasSubscription
            }
        } catch {
            print("구독 상태 확인 오류: \(error.localizedDescription)")
        }
    }
    
    func subscribeToNewPhotos() async throws {
        // 1. 기존 구독 확인 및 삭제
        do {
            let subscriptions = try await database.allSubscriptions()
            
            // 기존 구독이 있다면 삭제
            for subscription in subscriptions where subscription.subscriptionID == "newPhotosSubscription" {
                try await database.deleteSubscription(withID: subscription.subscriptionID)
            }
            
            // 2. 새로운 구독 생성
            let predicate = NSPredicate(value: true)
            let subscription = CKQuerySubscription(
                recordType: "UserPhoto",
                predicate: predicate,
                subscriptionID: "newPhotosSubscription",
                options: [.firesOnRecordCreation]
            )
            
            // 3. 알림 정보 설정
            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.alertBody = "새로운 사진이 추가되었습니다!"
            notificationInfo.shouldBadge = true
            notificationInfo.shouldSendContentAvailable = true  // silent push를 위한 설정
            notificationInfo.category = "NEW_PHOTO"  // 알림 카테고리 설정
            notificationInfo.soundName = "default"
            
            subscription.notificationInfo = notificationInfo
            
            // 4. 구독 저장
            try await database.save(subscription)
            print("Push notification 구독 성공")
            
            await MainActor.run {
                self.subscriptionActive = true
            }
        } catch {
            print("Push notification 구독 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    func unsubscribeFromPhotos() async throws {
        do {
            try await database.deleteSubscription(withID: "newPhotosSubscription")
            await MainActor.run {
                self.subscriptionActive = false
            }
            print("구독 취소 성공")
        } catch {
            print("구독 취소 실패: \(error.localizedDescription)")
            throw error
        }
    }
    // CloudKitManager에 추가
    func clearCache() {
        // NSCache 비우기
        cache.removeAllObjects()
        print("메모리 캐시 비움")
    }
}
