//
//  DDayViewModel.swift
//  HWYU
//
//  Created by Yungui Lee on 7/18/24.
//

import Foundation
import Combine
import UIKit

class DDayViewModel: ObservableObject {
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    
    @Published var currentDaysCount = 0
    @Published var selectedImage: UIImage?
    private let imageCache = ImageCache.shared
    
    // MARK: - Count Day
    
    func countDay() async {
        currentDaysCount = 0
        let targetCount = daysSinceStart()

        for i in 0...targetCount {
            DispatchQueue.main.async {
                self.currentDaysCount = i
            }
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
    
    // MARK: - Load Random Image
    
    func loadRandomImage(from images: [ImageModel]) async {
        guard let randomImage = images.randomElement() else {
            selectedImage = nil
            print("No images available")
            return
        }
        
        let imageId = randomImage.id.uuidString
        
        if let cachedImage = imageCache.getImage(forKey: imageId) {
            selectedImage = cachedImage
            print("getImage")
        } else if let imageData = randomImage.imageData, let uiImage = UIImage(data: imageData) {
            imageCache.setImage(uiImage, forKey: imageId)
            selectedImage = uiImage
            print("setImage")

        } else {
            selectedImage = nil
            print("Failed to load image")
        }
    }
}

