//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI
import SwiftData

struct DDayView: View {
    @StateObject private var dDayViewModel = DDayViewModel()
    
    @State private var showLetter: Bool = false
    @State private var showAlbum: Bool = false
    private let imageCache = ImageCache.shared

    /// Swift Data
    @Query var images: [ImageModel]
    @Environment(\.modelContext) var modelContext
        
    var body: some View {
        NavigationStack {
            ZStack {
                if let image = dDayViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .center) {
                    HStack {
                        Text("혜원")
                            .font(Font.custom("GowunBatang-Bold", size: 17))
                        
                        Button {
                            Task {
                                await reloadPage()
                            }
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                        }

                        Text("융의")
                            .font(Font.custom("GowunBatang-Bold", size: 17))
                    }
                    .padding(.vertical)
                    
                    HStack(spacing: 0) {
                        Button("우리") {
                        }
                        .simultaneousGesture(LongPressGesture(minimumDuration: 1.3).onEnded { _ in
                            showLetter = true
                        })
                        .font(Font.custom("GowunBatang-Bold", size: 14))
                        .foregroundStyle(.gray)
                        
                        Text("가 함께한 지 벌써 \(dDayViewModel.currentDaysCount)일!")
                            .font(Font.custom("GowunBatang-Bold", size: 14))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()

                    HStack {
                        Text(dDayViewModel.formatDate(dDayViewModel.startDate))
                        
                        Button(action: {
                            showAlbum = true
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color("mainColor"))
                        }
                        
                        Text("~")
                    }
                    .font(.headline)
                    .foregroundColor(.white)

                    Text(dDayViewModel.formatDate(Date()))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)

                    HStack {
                        Button {
                            Task {
                                await reloadPage()
                            }
                        } label: {
                            Text("\(dDayViewModel.currentDaysCount)")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .italic()
                        }
                        

                        Image(systemName: "arrowshape.up.fill")
                    }
                    
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1, x: 1, y: 1)

                }
            }
            .task {
                await reloadPage()
            }
            .sheet(isPresented: $showLetter) {
                LetterListView()
            }
            .fullScreenCover(isPresented: $showAlbum) {
                ImageListView().environmentObject(dDayViewModel)
            }
        }
    }
    
    private func reloadPage() async {
        await dDayViewModel.loadRandomImage(from: images)
        await dDayViewModel.countDay()
    }
}

#Preview {
    DDayView()
        .modelContainer(for: ImageModel.self, inMemory: true)
}
