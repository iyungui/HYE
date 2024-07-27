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
    
    @State private var zoomLevel: CGFloat = 1.0
    
    var columns: [GridItem] {
        let columnCount = zoomLevel < 1.5 ? 3 : 2
        return Array(repeating: .init(.flexible(), spacing: 6), count: columnCount)
    }
    
    @State var selectedImage: ImageModel?
    @State private var showAddImageSheet: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: []) {
                ForEach(images) { image in
                    if let imageData = image.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / CGFloat(columns.count), height: UIScreen.main.bounds.width / CGFloat(columns.count))
                            .clipped()
                            .contextMenu {
                                Button {
                                    selectedImage = image
                                    showAlert = true
                                } label: {
                                    Label("삭제하기", systemImage: "trash")
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
//            .sheet(item: $selectedImage) { image in
//                ImageDetailView(image: image)
//            }
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
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    let newZoomLevel = zoomLevel * value.magnification
                    if newZoomLevel >= 1.0 && newZoomLevel <= 2.0 {
                        withAnimation {
                            zoomLevel = newZoomLevel
                        }
                    }
                }
        )
    }
}

//
//struct ImageDetailView: View {
//    let image: UIImage
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "xmark")
//                            .foregroundStyle(.gray)
//                    }
//                }
//            }
//        }
//    }
//}

#Preview {
    NavigationStack {
        ImageListView()
            .modelContainer(for: ImageModel.self, inMemory: true)
    }
}
