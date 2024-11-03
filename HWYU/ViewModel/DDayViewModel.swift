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
    
    private let cloudKitManager: CloudKitManager

    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    // MARK: - Count Day
    
    @MainActor
    func countDay() async {
        currentDaysCount = 0
        let targetCount = daysSinceStart()

        for i in 0...targetCount {
            // 메인 스레드에서 실행되므로 DispatchQueue.main.async를 사용할 필요 없음
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
    
    @MainActor
    func loadRandomImage() async {
        await withCheckedContinuation { continuation in
            cloudKitManager.fetchRandomImage { randomImage in
                if let image = randomImage {
                    self.selectedImage = image
                } else {
                    self.selectedImage = nil
                    print("No images available.")
                }
                continuation.resume() // 작업 완료를 알림
            }
        }
    }
}
