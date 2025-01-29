//
//  LetterView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/22/24.
//

import SwiftUI

struct LetterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage: Int = 0
    let letter: Letter
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(0..<letter.content.count, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack(spacing: 20) {
                            Spacer() // 상단 여백 추가
                            
                            VStack {
                                ZStack {
                                    Image(letter.images[index % letter.images.count])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 400)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .offset(x: phase.isIdentity ? 0 : phase.value * -200)
                                        }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 36))
                            }
                            .frame(height: 400)
                            
                            ScrollView(.vertical) {
                                Text(letter.content[index])
                                    .multilineTextAlignment(.center)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .italic()
                                    .frame(width: 300)
                                    .padding(.vertical)
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1 : 0)
                                            .offset(x: phase.value * 100)
                                    }
                            }
                            .frame(height: 100)
                            
                            if index == letter.content.count - 1 {
                                Button("안녕!") {
                                    dismiss()
                                }
                            }
                            Spacer() // 하단 여백 추가
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .containerRelativeFrame(.horizontal)
                }
            }
        }
        .scrollTargetLayout()
        .contentMargins(32)
        .scrollTargetBehavior(.viewAligned)
    }
}
#Preview {
    LetterView(letter: Letter.letterList.first!)
}
