//
//  AppDelegate.swift
//  HWYU
//
//  Created by 이융의 on 4/15/25.
//

import UIKit
import CloudKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // APNS 설정
        UNUserNotificationCenter.current().delegate = self
        
        // CloudKit 변경 사항에 대한 알림 옵저버 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCloudKitNotification(_:)),
            name: .init("CKAccountChanged"),
            object: nil
        )
        
        return true
    }
    
    // 원격 알림 등록 성공 처리
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("디바이스 토큰: \(token)")
    }
    
    // 원격 알림 등록 실패 처리
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("푸시 알림 등록 실패: \(error.localizedDescription)")
    }
    
    // 원격 알림 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // CloudKit 알림인지 확인
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) {
            print("CloudKit 알림 수신: \(notification.notificationID?.description ?? "")")
            
            if notification.notificationType == .query,
               let queryNotification = notification as? CKQueryNotification {
                
                handleQueryNotification(queryNotification)
                completionHandler(.newData)
                return
            }
        }
        
        completionHandler(.noData)
    }
    
    // 포그라운드에서 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 포그라운드에 있어도 알림 표시
        completionHandler([.banner, .sound, .badge])
    }
    
    // 알림 탭 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo),
           notification.notificationType == .query,
           let queryNotification = notification as? CKQueryNotification {
            
            handleQueryNotification(queryNotification)
        }
        
        completionHandler()
    }
    
    // CloudKit 알림 처리
    @objc private func handleCloudKitNotification(_ notification: Notification) {
        // CloudKit 계정 변경 처리
        print("CloudKit 계정 변경됨")
    }
    
    // 쿼리 알림 처리
    private func handleQueryNotification(_ notification: CKQueryNotification) {
        switch notification.queryNotificationReason {
        case .recordCreated:
            print("새 사진 업로드됨")
            
            // NotificationCenter를 통해 앱 내부에 새 이미지 알림
            NotificationCenter.default.post(
                name: .newPhotoUploaded,
                object: nil,
                userInfo: ["recordID": notification.recordID?.recordName ?? ""]
            )
            
        case .recordUpdated:
            print("사진 업데이트됨")
            
        case .recordDeleted:
            print("사진 삭제됨")
            
        @unknown default:
            break
        }
    }
}

// 커스텀 NotificationCenter 이름
extension Notification.Name {
    static let newPhotoUploaded = Notification.Name("newPhotoUploaded")
}
