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
    @Environment(\.modelContext) var modelContext
    
    @State var selectedPhotoItems: [PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 10, selectionBehavior: .continuousAndOrdered, matching: .images, preferredItemEncoding: .automatic) {
                    if selectedImages.isEmpty {
                        ContentUnavailableView("사진 선택", systemImage: "photo.on.rectangle", description: Text("한 번에 여러 개의 사진을 추가할 수 있어요."))
                            .frame(height: 300)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .clipShape(.rect(cornerRadius: 20))
                                        .padding(.horizontal, 5)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 300)
                    }
                }
                .onChange(of: selectedPhotoItems) { _, newItems in
                    selectedImages.removeAll()
                    for item in newItems {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data, let image = UIImage(data: data) {
                                    selectedImages.append(image)
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        if !selectedImages.isEmpty {
                            addImages(images: selectedImages)
                            showAlert = true
                            alertMessage = "이미지가 성공적으로 업로드 되었습니다."
                        } else {
                            print("No Images Selected")
                            showAlert = true
                            alertMessage = "이미지 업로드에 실패했습니다."
                        }
                    }) {
                        Text("추가")
                            .bold()
                    }
                    .disabled(selectedImages.isEmpty)
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
    
    private func addImages(images: [UIImage]) {
        for image in images {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let newImageModel = ImageModel(imageData: imageData)
                modelContext.insert(newImageModel)
            }
        }
    }
}

#Preview {
    AddImageView()
        .modelContainer(for: ImageModel.self, inMemory: true)
}
