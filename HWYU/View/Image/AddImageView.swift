//
//  AddImageView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/26/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddImageView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var selectedPhotoItem: [PhotosPickerItem] = []
    @State var data: Data?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
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
                    Button(action: {
                        if let data = data {
                            addImage(imageData: data)
                            showAlert = true
                            alertMessage = "이미지가 성공적으로 업로드 되었습니다."
                        } else {
                            print("No Image Data")
                            showAlert = true
                            alertMessage = "이미지 업로드에 실패했습니다."
                        }
                    }) {
                        Text("업로드").bold()
                    }
                    .disabled(data == nil)
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
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addImage(imageData: Data) {
        let newImageModel = ImageModel(imageData: imageData)
        modelContext.insert(newImageModel)
    }
}

#Preview {
    AddImageView()
        .modelContainer(for: ImageModel.self, inMemory: true)
}
