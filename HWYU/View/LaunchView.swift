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
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "ffb6a9"),
                    Color(hex: "ffb3c3")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// Color Extension to use hex values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LaunchView()
}


