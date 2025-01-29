//
//  DDayViewModel.swift
//  HWYU
//
//  Created by Yungui Lee on 7/18/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class DDayViewModel: ObservableObject {
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    
    @Published var currentDaysCount = 0
    @Published var selectedImage: UIImage?
    @Published private(set) var isLoading = false
    private let cloudKitManager: CloudKitManager

    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    @MainActor
    func loadRandomImage() async {
        guard !isLoading else { return }  // 이미 로딩 중이면 중복 실행 방지
        isLoading = true
        
        do {
            print("LOAD RANDOM IMAGE\n")
            self.selectedImage = try await cloudKitManager.fetchRandomImage()
        } catch {
            print("Error loading random image: \(error.localizedDescription)")
            self.selectedImage = nil
        }
        
        isLoading = false
    }
    
    // MARK: - Count Day
    
    @MainActor
    func countDay() async {
        currentDaysCount = 0
        let targetCount = daysSinceStart()

        for i in 0...targetCount {
            self.currentDaysCount = i
            try? await Task.sleep(for: .milliseconds(3))
        }
    }
    
    // Calculates the number of days since the start
    private func daysSinceStart() -> Int {
        let today = Date()
        guard today > startDate else { return 0 }
        
        let components = Calendar.current.dateComponents([.day], from: startDate, to: today)
        
        return components.day ?? 0
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
}
