//
//  DDayViewModel.swift
//  HWYU
//
//  Created by Yungui Lee on 7/18/24.
//

import Foundation
import Combine

class DDayViewModel: ObservableObject {
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    
    var imageNames: [String] {
        return (1...7).map { String(format: "image%02d", $0) }
    }
    
    @Published var currentDaysCount = 0
    @Published var currentImageName = "image01"
        
    init() {
        countDay()
        loadImage()
    }
    
    // MARK: - Count Day
    
    func countDay() {
        currentDaysCount = 0
        let targetCount = daysSinceStart()
        
        Timer.scheduledTimer(withTimeInterval: 0.003, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.currentDaysCount < targetCount {
                self.currentDaysCount += 1
            } else {
                timer.invalidate()
            }
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
    
    // MARK: - Load Image
    
    func loadImage() {
        var newImage: String
        repeat {
            newImage = imageNames.randomElement() ?? "image01"
        } while newImage == currentImageName
        currentImageName = newImage
    }
}
