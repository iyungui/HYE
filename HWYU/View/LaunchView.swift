//
//  LaunchView.swift
//  HWYU
//
//  Created by Yungui Lee on 1/23/25.
//

import SwiftUI
import Lottie

//struct LaunchView: UIViewRepresentable {
//    let animationName: String
//    let loopMode: LottieLoopMode
//    
//    func makeUIView(context: Context) -> LottieAnimationView {
//        let animationView = LottieAnimationView(name: animationName)
//        animationView.loopMode = loopMode
//        animationView.contentMode = .scaleAspectFit
//        animationView.play()
//        return animationView
//    }
//    
//    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
//}
//
//#Preview {
//    LaunchView(animationName: "Animation - 1738161873830", loopMode: .loop)
//}

struct LaunchView: View {
    var body: some View {
        VStack {
            Text("로딩뷰")
        }
    }
}

#Preview {
    LaunchView()
}


