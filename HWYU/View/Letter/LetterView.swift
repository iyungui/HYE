//
//  LetterView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/22/24.
//

import SwiftUI

struct LetterView: View {
    @State private var currentPage: Int = 0
    
    let letter: Letter

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<letter.content.count, id: \.self) { index in
                    LetterDetailView(letterText: letter.content, index: index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
            
            // 페이지 변경 버튼 추가
            HStack {
                Button(action: {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }) {
                    Text("이전")
                }
                .disabled(currentPage == 0) // 첫 페이지에서는 비활성화

                Spacer()

                Button(action: {
                    if currentPage < letter.content.count - 1 {
                        currentPage += 1
                    }
                }) {
                    Text("다음")
                }
                .disabled(currentPage == letter.content.count - 1) // 마지막 페이지에서는 비활성화
            }
            .padding()
        }
        .padding()
    }
}

struct LetterDetailView: View {
    let letterText: [String]
    let index: Int
    
    var images: [String] {
        return (1...7).map { String(format: "image%02d", $0) }
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Spacer()
            
            Image(images[index % images.count])
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Text(letterText[index % letterText.count])
                .font(Font.custom("GowunBatang-Regular", size: 17))
                .padding()
            
            
            HStack {
                Spacer()
                Text("\(index + 1) / \(letterText.count)")
                    .font(Font.custom("GowunBatang-Regular", size: 13))
                    .foregroundStyle(.gray)
                    .padding()
            }
            .padding(.bottom)
            
            if index + 1 == letterText.count {
                Button("안녕!") {
                    dismiss()
                }
            }
            
            Spacer()

        }
        .padding()
    }
}

#Preview {
    LetterView(letter: Letter.letterList.first!)
}
