//
//  ContentView.swift
//  HWYU
//
//  Created by Yungui Lee on 1/29/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLaunch: Bool = true
    @StateObject private var dDayViewModel: DDayViewModel
    
    init() {
        let app = UIApplication.shared.delegate as? AppDelegate
        let appScene = UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate
        
        if let app = UIApplication.shared as? HWYUApp {
            _dDayViewModel = StateObject(wrappedValue: DDayViewModel(cloudKitManager: app.cloudKitManager))
        } else {
            // 기본 인스턴스 생성 (앱 초기화 시에만 사용)
            _dDayViewModel = StateObject(wrappedValue: DDayViewModel(cloudKitManager: CloudKitManager()))
        }
    }
    
    var body: some View {
        if isLaunch {
            LaunchView()
                .task {
                    await dDayViewModel.loadRandomImage()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        isLaunch = false
                    }
                }
        } else {
            DDayView().environmentObject(dDayViewModel)
        }
    }
}


