//
//  CloudKitManager.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import CloudKit
import UIKit

class CloudKitManager: ObservableObject {
    private let database = CKContainer.default().publicCloudDatabase
    @Published var images: [UIImage] = []

    func uploadImage(image: UIImage, completion: @escaping (Bool) -> Void) {
        // 1. 이미지 크기 조정 (예: 최대 500x500)
        let maxSize = CGSize(width: 500, height: 500)
        guard let resizedImage = image.resized(to: maxSize),
              let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return
        }
        
        let imageURL = saveToTemporaryDirectory(data: imageData)
        
        let record = CKRecord(recordType: "UserPhoto")
        record["photo"] = CKAsset(fileURL: imageURL)
        record["uploadDate"] = Date() // 업로드 날짜 추가

        // Step 1: Check and delete oldest if more than 10
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: true)
        query.sortDescriptors = [sortDescriptor]
        
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 0) { result in
            switch result {
            case .success(let (matchResults, _)):
                let records = matchResults.compactMap { try? $0.1.get() }
                
                if records.count >= 10 {
                    // 가장 오래된 레코드를 삭제합니다.
                    if let oldestRecord = records.first {
                        self.database.delete(withRecordID: oldestRecord.recordID) { _, deleteError in
                            if let deleteError = deleteError {
                                print("Error deleting record: \(deleteError.localizedDescription)")
                                completion(false)
                                return
                            }
                            // 새 이미지를 저장합니다.
                            self.saveNewImageRecord(record, completion: completion)
                        }
                    }
                } else {
                    // 10개 미만이므로 새로운 이미지를 직접 저장합니다.
                    self.saveNewImageRecord(record, completion: completion)
                }
            case .failure(let error):
                print("Error fetching records: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    private func saveNewImageRecord(_ record: CKRecord, completion: @escaping (Bool) -> Void) {
        database.save(record) { savedRecord, error in
            if let error = error {
                print("Error saving new image: \(error.localizedDescription)")
                completion(false)
            } else {
                self.fetchImages() // 새 이미지가 추가된 후 즉시 업데이트
                completion(true)
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

    func fetchImages() {
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 0) { result in
            switch result {
            case .success(let (matchResults, _)):
                DispatchQueue.main.async {
                    self.images = matchResults.compactMap {
                        if let record = try? $0.1.get(),
                           let asset = record["photo"] as? CKAsset,
                           let fileURL = asset.fileURL,
                           let data = try? Data(contentsOf: fileURL),
                           let image = UIImage(data: data) {
                            return image
                        }
                        return nil
                    }
                }
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRandomImage(completion: @escaping (UIImage?) -> Void) {
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 0) { result in
            switch result {
            case .success(let (matchResults, _)):
                let records = matchResults.compactMap { try? $0.1.get() }
                
                guard !records.isEmpty else {
                    completion(nil) // 이미지가 없는 경우 nil 반환
                    return
                }
                
                // 랜덤으로 하나의 레코드 선택
                let randomRecord = records.randomElement()
                if let asset = randomRecord?["photo"] as? CKAsset,
                   let fileURL = asset.fileURL,
                   let data = try? Data(contentsOf: fileURL),
                   let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
                
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    // MARK: - APNS
    func subscribeToNewPhotos() {
        // 고유한 식별자를 가진 구독 생성
        let subscriptionID = "newPhotosSubscription"
        let subscription = CKQuerySubscription(
            recordType: "UserPhoto",
            predicate: NSPredicate(value: true),
            subscriptionID: subscriptionID,
            options: .firesOnRecordCreation // 새 레코드 생성 시 알림
        )

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "앨범에 새 사진을 추가했어요."
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        
        subscription.notificationInfo = notificationInfo

        database.save(subscription) { result, error in
            if let error = error {
                print("Error subscribing to new photos: \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to new photos.")
            }
        }
    }
}
extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
