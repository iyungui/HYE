//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI

struct DDayView: View {
    @State private var images: [UIImage] = []
    
    @EnvironmentObject private var dDayViewModel: DDayViewModel
    @State private var showLetter: Bool = false
    @State private var showAlbum: Bool = false

    let emojis: [Emoji] = Emoji.emojis
    @State private var currentEmoji: String = "heart.fill" // 초기 아이콘 설정

    var body: some View {
        NavigationStack {
            ZStack {
                if let image = dDayViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.25)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .center) {
                    HStack {
                        Text("혜원")
                            .font(Font.custom("GowunBatang-Bold", size: 17))
                        
                        Button {
                            // 누를 때마다 랜덤 이모지 선택
                            currentEmoji = emojis.randomElement()?.content ?? "heart.fill"
                        } label: {
                            if currentEmoji == "heart.fill" {
                                Image(systemName: currentEmoji) // 처음엔 하트 아이콘
                                    .font(.title3)
                                    .foregroundColor(.green)
                            } else {
                                Text(currentEmoji) // 이모지로 변경
                                    .font(.title3)
                            }
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
                            .font(Font.custom("GowunBatang-Bold", size: 17))

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
                        .font(Font.custom("GowunBatang-Bold", size: 17))
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
                await dDayViewModel.countDay()
//                await reloadPage()
            }
            .fullScreenCover(isPresented: $showLetter) {
                LetterListView()
            }
            .fullScreenCover(isPresented: $showAlbum) {
                ImageListView().environmentObject(dDayViewModel)
            }
        }
    }
    
    private func reloadPage() async {
        await dDayViewModel.loadRandomImage()
        await dDayViewModel.countDay()
    }
}

#Preview {
    DDayView()
        .environmentObject(DDayViewModel(cloudKitManager: CloudKitManager()))
}
