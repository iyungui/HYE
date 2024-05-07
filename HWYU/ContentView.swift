//
//  ContentView.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 80) {
                ForEach(0..<10) { index in
                    AnimatedTextView(index: index)
                }
            }
            .padding()
        }
    }
}

struct AnimatedTextView: View {
    var index: Int
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = UIScreen.main.bounds.height
            let minY = geometry.frame(in: .global).minY
            
            let scaleEffect = min(1.2, max(0.5, (minY - 50) / (screenHeight - 100)))
            let opacityEffect = min(1.0, max(0.0, (minY - 50) / (screenHeight - 100)))
            
            Text("This is item \(index + 1)")
                .font(.largeTitle)
                .bold()
                .scaleEffect(scaleEffect)
                .opacity(opacityEffect)
                .frame(maxWidth: .infinity, alignment: .center)
                .animation(.easeInOut(duration: 0.5), value: scaleEffect)
                .animation(.easeInOut(duration: 0.5), value: opacityEffect)
        }
        .frame(height: 200)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
