//
//  ImageListView.swift
//  HWYU
//
//  Created by Yungui Lee on 7/25/24.
//

import SwiftUI

@available(iOS 18.0, *)
struct ImageListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dDayViewModel: DDayViewModel
    @ObservedObject private var cloudKitManager = CloudKitManager()
    @Namespace private var namespace
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 6), count: 3)
    @State private var showAddImageSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 3) {
                        ForEach(cloudKitManager.images.indices, id: \.self) { index in
                            let image = cloudKitManager.images[index]
                            NavigationLink {
                                ImageDetailView(image: image)
                                    .navigationTransition(.zoom(sourceID: index, in: namespace))
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: UIScreen.main.bounds.width / 3,
                                        height: UIScreen.main.bounds.width / 3
                                    )
                                    .clipped()
                                    .matchedTransitionSource(id: index, in: namespace)
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
                    .navigationTitle("공유 앨범")
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
                            Text("\(cloudKitManager.images.count) Photos")
                                .font(.headline)
                        }
                    }
                }

                .task {
                    await cloudKitManager.fetchImages()
                }
                if cloudKitManager.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .controlSize(.large)
                        .tint(.white)
                }
            }
            .sheet(isPresented: $showAddImageSheet) {
                AddImageView()
                    .presentationDetents([.medium, .large])
                    .environmentObject(cloudKitManager)
            }
        }
    }
}

@available(iOS 18.0, *)
struct ImageDetailView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

// Preview도 iOS 18.0 이상으로 설정
@available(iOS 18.0, *)
#Preview {
    NavigationStack {
        ImageListView()
            .environmentObject(DDayViewModel(cloudKitManager: CloudKitManager()))
    }
}
