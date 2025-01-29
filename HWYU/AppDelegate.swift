////
////  AppDelegate.swift
////  HWYU
////
////  Created by Yungui Lee on 11/3/24.
////
//
//import Foundation
//import UIKit
//import UserNotifications
//
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//   
//   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//       // 델리게이트 설정을 가장 먼저
//       UNUserNotificationCenter.current().delegate = self
//       
//       // 푸시 알림 권한 요청만 하기
//       requestNotificationAuthorization()
//       
//       return true
//   }
//   
//   private func requestNotificationAuthorization() {
//       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//           if granted {
//               print("Push notification 권한 승인됨")
//               DispatchQueue.main.async {
//                   UIApplication.shared.registerForRemoteNotifications()
//               }
//           } else {
//               print("Push notification 권한 거부됨: \(error?.localizedDescription ?? "error unknown")")
//           }
//       }
//   }
//   
//   // MARK: - Remote Notifications
//   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//       let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//       print("APNs 디바이스 토큰: \(tokenString)")
//   }
//   
//   func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//       print("APNs 등록 실패: \(error.localizedDescription)")
//   }
//   
//   func applicationDidBecomeActive(_ application: UIApplication) {
//       resetBadge()
//   }
//   
//   private func resetBadge() {
//       UNUserNotificationCenter.current().setBadgeCount(0) { error in
//           if let error = error {
//               print("Failed to reset badge: \(error.localizedDescription)")
//           }
//       }
//   }
//   
//   // MARK: - UNUserNotificationCenterDelegate
//   // 앱이 포그라운드에서 실행 중일 때도 알림을 표시
//   func userNotificationCenter(_ center: UNUserNotificationCenter,
//                             willPresent notification: UNNotification,
//                             withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//       completionHandler([.banner, .sound, .badge])
//   }
//   
//   // 알림을 탭했을 때 처리
//   func userNotificationCenter(_ center: UNUserNotificationCenter,
//                             didReceive response: UNNotificationResponse,
//                             withCompletionHandler completionHandler: @escaping () -> Void) {
//       // 알림 관련 처리를 여기서 구현
//       resetBadge()
//       print("사용자가 알림을 탭함")
//       completionHandler()
//   }
//}
