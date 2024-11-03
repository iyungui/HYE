//
//  ImageListView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import SwiftUI
import SwiftData

struct ImageListView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dDayViewModel: DDayViewModel
    @StateObject private var cloudKitManager = CloudKitManager()

    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 6), count: 3)
    
    @State var selectedImage: UIImage?
    @State private var images: [UIImage] = []

    @State private var showAddImageSheet: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 3, pinnedViews: []) {
                    ForEach(images, id: \.self) { image in
                        NavigationLink(destination: ImageDetailView(image: image)) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: UIScreen.main.bounds.width / 3,
                                    height: UIScreen.main.bounds.width / 3
                                )
                                .clipped()
                                .contextMenu {
                                    Button {
                                        dDayViewModel.selectedImage = image
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
            }
            .task {
                loadImages()
            }
        }
    }
    private func loadImages() {
        cloudKitManager.fetchImages { fetchedImages in
            DispatchQueue.main.async {
                self.images = fetchedImages
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImageListView()
            .environmentObject(DDayViewModel(cloudKitManager: CloudKitManager()))
    }
}
