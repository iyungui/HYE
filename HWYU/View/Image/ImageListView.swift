//
//  ImageListView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import SwiftUI
import SwiftData

struct ImageListView: View {
    /// Swift Data
    @Query(sort: \ImageModel.date, order: .reverse) var images: [ImageModel]
    @Environment(\.modelContext) var modelContext
        
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 6), count: 3)
    
    @State var selectedImage: ImageModel?
    @State private var showAddImageSheet: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: []) {
                ForEach(images) { image in
                    if let imageData = image.imageData, let uiImage = UIImage(data: imageData) {
                        NavigationLink(destination: ImageDetailView(image: image)) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: UIScreen.main.bounds.width / 3,
                                    height: UIScreen.main.bounds.width / 3
                                )
                                .clipped()
                                .contextMenu {
                                    Button {
                                        selectedImage = image
                                        showAlert = true
                                    } label: {
                                        Label("삭제하기", systemImage: "trash")
                                            .foregroundStyle(.red)
                                    }
                                    
                                }
                        }
                    }
                }
            }
            .padding(.top, 10)
            .navigationTitle("앨범")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddImageSheet = true
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddImageSheet) {
                AddImageView()
            }
            .alert("알림", isPresented: $showAlert) {
                Button("네", role: .destructive) {
                    if let image = selectedImage {
                        modelContext.delete(image)
                    } else {
                        print("SelectedImage is nil")
                    }
                }
                Button("취소", role: .cancel) {}
                
            } message: {
                Text("정말로 삭제하시겠어요?")
            }
        }
    }
}


struct ImageDetailView: View {
    let image: ImageModel
    
    
    var body: some View {
        VStack {
            if let imageData = image.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImageListView()
            .modelContainer(for: ImageModel.self, inMemory: true)
    }
}
