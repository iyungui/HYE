//
//  AppState.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isDataLoaded = false // 데이터 로드 상태
    let dDayViewModel = DDayViewModel(cloudKitManager: CloudKitManager())
    
    init() {
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        await dDayViewModel.loadRandomImage()
        
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        DispatchQueue.main.async {
            self.isDataLoaded = (self.dDayViewModel.selectedImage != nil)
        }
    }
}
