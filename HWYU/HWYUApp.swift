//
//  HWYUApp.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

@main
struct HWYUApp: App {
    // AppDelegate 등록
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // 공유 CloudKitManager 인스턴스
    let cloudKitManager = CloudKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 백그라운드 모드 설정
                    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
                    
                    // CloudKit 설정
                    configureCloudKit()
                }
        }
    }
    
    private func configureCloudKit() {
        // CloudKit 알림 설정 및 푸시 권한 요청
        cloudKitManager.requestNotificationPermission()
        
        // CloudKit에서 초기 데이터 로드
        Task {
            try? await Task.sleep(for: .seconds(1))
            await cloudKitManager.checkSubscriptionStatus()
        }
    }
}
