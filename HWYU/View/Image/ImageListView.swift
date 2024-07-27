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
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dDayViewModel: DDayViewModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 6), count: 3)
    
    @State var selectedImage: ImageModel?
    @State private var showAddImageSheet: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: []) {
                    ForEach(images) { image in
                        if let imageData = image.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: UIScreen.main.bounds.width / 3,
                                    height: UIScreen.main.bounds.width / 3
                                )
                                .clipped()
                                .contextMenu {
                                    Button(role: .destructive) {
                                        selectedImage = image
                                        showAlert = true
                                    } label: {
                                        Label("삭제하기", systemImage: "trash")
                                    }
                                    Button {
                                        dDayViewModel.selectedImage = uiImage
                                        dismiss()
                                    } label: {
                                        Label("배경으로 설정", systemImage: "photo.badge.checkmark")
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
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Text("\(images.count) Photos")
                            .font(.headline)
                    }
                }
                .sheet(isPresented: $showAddImageSheet) {
                    AddImageView()
                        .presentationDetents([.medium, .large])
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
}

#Preview {
    NavigationStack {
        ImageListView()
            .modelContainer(for: ImageModel.self, inMemory: true)
            .environmentObject(DDayViewModel())
    }
}
