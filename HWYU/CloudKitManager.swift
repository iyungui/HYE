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

    func uploadImage(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
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

    func fetchImages(completion: @escaping ([UIImage]) -> Void) {
        let query = CKQuery(recordType: "UserPhoto", predicate: NSPredicate(value: true))
        let sortDescriptor = NSSortDescriptor(key: "uploadDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 0) { result in
            switch result {
            case .success(let (matchResults, _)):
                var images: [UIImage] = []
                
                for matchResult in matchResults {
                    switch matchResult.1 {
                    case .success(let record):
                        if let asset = record["photo"] as? CKAsset, let fileURL = asset.fileURL, let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                            images.append(image)
                        }
                    case .failure(let error):
                        print("Error loading record: \(error.localizedDescription)")
                    }
                }
                completion(images)
                
            case .failure(let error):
                print("Error fetching images: \(error.localizedDescription)")
                completion([])
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
}
