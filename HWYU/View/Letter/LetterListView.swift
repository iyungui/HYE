//
//  LetterListView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/18/24.
//

import SwiftUI

struct LetterListView: View {
    @Environment(\.dismiss) var dismiss
    let letters = Letter.letterList
    @State private var showAlert: Bool = false
    @State private var selectedLetter: Letter?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(letters) { letter in
                    Button(action: {
                        // 특정 편지를 선택하면 alert 표시
                        if letter.date == "2024-11-03" && letter.title == "너에게 보내는 두 번째 편지" {
                            showAlert = true
                        } else {
                            // 다른 편지일 경우에만 이동
                            navigateToLetter(letter)
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(letter.title)
                                .font(.headline)
                            Text(letter.date)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("편지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("지금은 읽을 수 없어요.")
            }
            .sheet(item: $selectedLetter) { letter in
                LetterView(letter: letter)
            }
        }
    }
    private func navigateToLetter(_ letter: Letter) {
        selectedLetter = letter
    }
}

#Preview {
    LetterListView()
}
