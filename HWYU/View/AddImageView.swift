//
//  AddImageView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/26/24.
//

import SwiftUI
import PhotosUI

struct AddImageView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedPhotoItem: [PhotosPickerItem] = []
    @State var data: Data?
    @State private var content: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $selectedPhotoItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                        if let data = data, let image = UIImage(data: data) {
                            VStack(alignment: .center) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                            }
                        } else {
                            Label("사진 선택", systemImage: "photo.artframe")
                        }
                    }.onChange(of: selectedPhotoItem) { _, newValue in
                        guard let item = selectedPhotoItem.first else {
                            return
                        }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                }
                            case .failure(let failure):
                                print("Error: \(failure.localizedDescription)")
                            }
                        }
                    }
                } header: {
                    Text("이미지")
                }
                
                Section {
                    TextField("여기에 텍스트를 입력하세요.", text: $content)
                } header: {
                    Text("한 줄 문장")
                }
                
                Section {
                    Button(action: {
                        
                    }) {
                        Text("업로드").bold()
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    AddImageView()
}
