//
//  LetterView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/22/24.
//

import SwiftUI

struct LetterView: View {
    @State private var currentPage: Int = 0

    var letterText: [String] {
        readTextFile()
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<letterText.count, id: \.self) { index in
                    LetterDetailView(letterText: letterText, index: index)
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
                    if currentPage < letterText.count - 1 {
                        currentPage += 1
                    }
                }) {
                    Text("다음")
                }
                .disabled(currentPage == letterText.count - 1) // 마지막 페이지에서는 비활성화
            }
            .padding()
        }
        .padding()
    }
    
    private func readTextFile() -> [String] {
        // 파일을 담을 변수 생성
        var result = ""
        var results: Array<String>
        
        guard let pahts = Bundle.main.path(forResource: "LetterTextOne.txt", ofType: nil) else { return [] }
        do {
            result = try String(contentsOfFile: pahts, encoding: .utf8)
            results = result.components(separatedBy: "\n")
            return results
        } catch {
            print("Error: file read failed - \(error.localizedDescription)")
            return []
        }
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
                .font(.body)
                .padding()
            
            
            HStack {
                Spacer()
                Text("\(index + 1) / \(letterText.count)")
                    .font(.caption)
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
    LetterView()
}
