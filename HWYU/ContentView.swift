//
//  ContentView.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

struct Ment: Identifiable {
    let id: UUID = UUID()
    var text: String
}

extension Ment {
    static let sampleMent: [Ment] = [
        Ment(text: ""),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 "),
        Ment(text: "1. 너를 방울방울해 ")

        ]
}

let gradientBackground = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.96, green: 0.91, blue: 0.83), // 연한 베이지
        Color(red: 0.87, green: 0.94, blue: 0.88), // 연한 그린
        Color.white
    ]),
    startPoint: .top,
    endPoint: .bottom
)

struct ContentView: View {
    let sampleMent: [Ment] =  Ment.sampleMent
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 100) {
                    ForEach(sampleMent) { ment in
                        AnimatedTextView(ment: ment)
                    }
                }
                .padding()
            }
            .navigationTitle("혜원이에게")
            .toolbarBackground(gradientBackground, for: .navigationBar)
            .background(gradientBackground)
        }
    }
}

struct AnimatedTextView: View {
    var ment: Ment
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = UIScreen.main.bounds.height
            let centerY = screenHeight / 2
            let minY = geometry.frame(in: .global).minY
            let distanceToCenter = abs(minY - centerY)
            let scaleEffect = max(0.5, 1 - (distanceToCenter / screenHeight))
            let opacityEffect = max(0.0, 1 - (distanceToCenter / (screenHeight / 2)))

            Text(ment.text)
                .font(.largeTitle)
                .bold()
                .scaleEffect(scaleEffect)
                .opacity(opacityEffect)
                .frame(maxWidth: .infinity, alignment: .center)
                .animation(.easeInOut(duration: 0.5), value: scaleEffect)
                .animation(.easeInOut(duration: 0.5), value: opacityEffect)
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

