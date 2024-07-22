//
//  EggView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/18/24.
//

import SwiftUI

struct EggView: View {
    @Binding var showEggView: Bool
    @State private var currentPage: Int = 0
    @State private var showTabView: Bool = false
    
    var letterText: [String] {
        readTextFile()
    }
    let name: String = "혜원이"
    let date: String = "2024-05-08"
    
    var body: some View {
        VStack {
            Button {
                showTabView.toggle()
            } label: {
                Text("\(name)에게")
                Text(date)
            }
            .font(showTabView ? .caption2 : .footnote)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)
            .foregroundColor(showTabView ? Color.blue : Color.gray)
            
            if showTabView {
                TabView(selection: $currentPage) {
                    ForEach(0..<letterText.count, id: \.self) { index in
                        LetterView(letterText: letterText, showEggView: $showEggView, index: index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .transition(.slide)
                .animation(.easeInOut, value: currentPage)
            }
        }
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

struct LetterView: View {
    let letterText: [String]
    
    @Binding var showEggView: Bool
    var index: Int
    
    var images: [String] {
        return (1...7).map { String(format: "image%02d", $0) }
    }

    var body: some View {
        VStack {
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
                Text("Page: \(index + 1) / \(letterText.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding()
            }
            
            if index + 1 == letterText.count {
                Button("안녕!") {
                    showEggView = false
                }
            }
        }
        .padding()
    }
}

#Preview {
    EggView(showEggView: .constant(false))
}
