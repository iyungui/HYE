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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(letters) { letter in
                    NavigationLink(destination: LetterView()) {
                        VStack(alignment: .leading) {
                            Text("\(letter.name)에게")
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
        }
    }

}

#Preview {
    LetterListView()
}
