//
//  ContentView.swift
//  HWYU
//
//  Created by Yungui Lee on 1/29/25.
//

import SwiftUI

// 먼저 사용할 애니메이션 이름들을 배열로 정의
extension String {
   static let animationNames = [
       "Animation - 1738161803316",
       "Animation - 1738161844869",
       "Animation - 1738161859369",
       "Animation - 1738161873830",
       "Animation - 1738161883849"
   ]
   
   static func randomAnimationName() -> String {
       animationNames.randomElement() ?? "animation"
   }
}

// ContentView에서 사용
struct ContentView: View {
   @State private var isLaunch: Bool = true
   @StateObject private var dDayViewModel = DDayViewModel(cloudKitManager: CloudKitManager())
   
   var body: some View {
       if isLaunch {
           LaunchView(animationName: .randomAnimationName(), loopMode: .loop)
               .task {
                   await dDayViewModel.loadRandomImage()
                   try? await Task.sleep(for: .seconds(1.5))
                   withAnimation(.linear) {
                       self.isLaunch = false
                   }
               }
       } else {
           DDayView().environmentObject(dDayViewModel)
       }
   }
}

#Preview {
    ContentView()
}
