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

@MainActor
class DDayViewModel: ObservableObject {
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    
    @Published var currentDaysCount = 0
    @Published var selectedImage: UIImage?
    @Published private(set) var isLoading = false
    @Published var loadingError: String?
    
    public let cloudKitManager: CloudKitManager
    private var loadingTask: Task<Void, Never>?
    private var countingTask: Task<Void, Never>?
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    deinit {
        loadingTask?.cancel()
        countingTask?.cancel()
    }
    
    @MainActor
    func loadRandomImage() async {
        // 기존 작업 취소
        loadingTask?.cancel()
        
        guard !isLoading else { return }  // 이미 로딩 중이면 중복 실행 방지
        
        isLoading = true
        loadingError = nil
        
        // 새 작업 시작
        loadingTask = Task {
            do {
                print("LOAD RANDOM IMAGE\n")
                
                // 최대 3번 재시도
                for attempt in 1...3 {
                    do {
                        if let image = try await cloudKitManager.fetchRandomImage() {
                            self.selectedImage = image
                            break
                        } else if attempt == 3 {
                            self.loadingError = "이미지를 불러올 수 없습니다."
                        }
                    } catch {
                        if attempt == 3 {
                            print("Error loading random image after 3 attempts: \(error.localizedDescription)")
                            self.loadingError = "이미지 로딩 실패: \(error.localizedDescription)"
                        }
                    }
                    
                    // 취소 확인
                    if Task.isCancelled {
                        break
                    }
                    
                    // 재시도 전 대기
                    if attempt < 3 {
                        try? await Task.sleep(for: .milliseconds(500))
                    }
                }
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Count Day
    
    @MainActor
    func countDay() async {
        // 기존 작업 취소
        countingTask?.cancel()
        
        let targetCount = daysSinceStart()
        
        // 이미 계산된 값과 같으면 애니메이션 스킵
        if currentDaysCount == targetCount {
            return
        }
        
        countingTask = Task {
            // 시작값 설정 - 0부터 시작하는 방식 유지
            self.currentDaysCount = 0
            
            // 애니메이션 지속 시간 설정 (날짜 수에 따라 조정)
            let duration: Double
            if targetCount > 300 {
                duration = 1.2  // 1.2초
            } else if targetCount > 100 {
                duration = 1.8  // 1.8초
            } else {
                duration = 2.5  // 2.5초
            }
            
            let startTime = Date()
            let endValue = Double(targetCount)
            
            // 스톱워치 느낌을 주는 가속 애니메이션
            while !Task.isCancelled {
                let elapsed = Date().timeIntervalSince(startTime)
                
                // 애니메이션 완료 확인
                if elapsed >= duration {
                    self.currentDaysCount = targetCount
                    break
                }
                
                // 진행률 계산 (0.0 ~ 1.0)
                let progress = elapsed / duration
                
                // 스톱워치 느낌의 가속 애니메이션 (점점 느려지는 효과)
                // 처음에는 빨리 증가하다가 목표치에 가까워질수록 천천히 증가
                let easedProgress = 1.0 - pow(1.0 - progress, 3)
                
                // 현재 표시할 값 계산 및 설정
                self.currentDaysCount = Int(endValue * easedProgress)
                
                // 프레임 간격 - 약 60fps
                try? await Task.sleep(for: .milliseconds(16))
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
    
    // 푸시 알림 구독 토글
    func togglePushNotifications() async {
        do {
            if cloudKitManager.subscriptionActive {
                try await cloudKitManager.unsubscribeFromPhotos()
            } else {
                try await cloudKitManager.subscribeToNewPhotos()
            }
        } catch {
            print("푸시 알림 설정 변경 실패: \(error.localizedDescription)")
        }
    }
}
