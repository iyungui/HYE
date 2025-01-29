////
////  AppState.swift
////  HWYU
////
////  Created by Yungui Lee on 11/3/24.
////
//
//import Foundation
//import SwiftUI
//import Combine
//
//@MainActor
//class AppState: ObservableObject {
//    @Published var isDataLoaded = false
//    let cloudKitManager: CloudKitManager
//    lazy var dDayViewModel: DDayViewModel = DDayViewModel(cloudKitManager: cloudKitManager)
//    
//    init() {
//        self.cloudKitManager = CloudKitManager()
//        
//        setupPushNotifications()
//        
//        Task {
//            await loadData()
//        }
//    }
//    
//    private func setupPushNotifications() {
//        cloudKitManager.subscribeToNewPhotos()
//    }
//    
//    func loadData() async {
//        await dDayViewModel.loadRandomImage()
//        self.isDataLoaded = (self.dDayViewModel.selectedImage != nil)
//    }
//}
