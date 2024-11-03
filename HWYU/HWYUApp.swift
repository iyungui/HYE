//
//  HWYUApp.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

@main
struct HWYUApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // AppDelegate 연결
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isDataLoaded {
                DDayView() // 메인 뷰로 전환
                    .environmentObject(appState.dDayViewModel)
            } else {
                SplashView()
            }
        }
    }
}
