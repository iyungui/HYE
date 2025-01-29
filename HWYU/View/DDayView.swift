//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI

struct DDayView: View {
    @EnvironmentObject private var dDayViewModel: DDayViewModel
    @State private var images: [UIImage] = []
    @State private var showLetter: Bool = false
    @State private var showAlbum: Bool = false
    
    let emojis: [Emoji] = Emoji.emojis
    @State private var currentEmoji: String = "heart.fill"
    @State private var isCountingFinished = true
    
    // quiz
    @State private var showingAlert = false
    @State private var answerString = ""
    @State private var flag = false
    @State private var count = 3
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
                
                dDayContent
            }
            .task {
                isCountingFinished = false
                await dDayViewModel.countDay()
                isCountingFinished = true
            }
            .alert("용이 하늘로 올라가면?", isPresented: $showingAlert) {
                TextField("여기에 입력하세요", text: $answerString)
                Button("확인", action: submit)
            } message: {
                Text((flag == false) ? "정답을 입력하세요~" : "땡!")
            }
            .alert("땡!", isPresented: $flag) {
                Button(role: .cancel) {
                    flag = false
                    if(count > 0) {
                        showingAlert = true
                    }
                } label: {
                    if(count > 0) {
                        Text("다시하기")
                    } else {
                        Text("닫기")
                    }
                }
            } message: {
                if(count > 0) {
                    Text("기회 \(count)번 남았습니다.")
                        .foregroundStyle(.red)
                } else {
                    Text("다음 기회에...")
                }
            }
            .fullScreenCover(isPresented: $showLetter) {
                LetterListView()
            }
            .fullScreenCover(isPresented: $showAlbum) {
                if #available(iOS 18.0, *) {
                    ImageListView().environmentObject(dDayViewModel)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    private func submit() {
        if(answerString == "올라가용~") {
            flag = false
            showLetter = true
        }
        else {
            flag = true
            count -= 1
            answerString = ""
        }
    }
    
    @ViewBuilder
    var dDayContent: some View {
        VStack(alignment: .center) {
            HStack {
                Text("혜원")
                    .font(Font.custom("GowunBatang-Bold", size: 17))
                
                Button {
                    // 누를 때마다 랜덤 이모지 선택
                    currentEmoji = emojis.randomElement()?.content ?? "heart.fill"
                } label: {
                    if currentEmoji == "heart.fill" {
                        Image(systemName: currentEmoji)
                            .font(.title3)
                            .foregroundColor(.green)
                    } else {
                        Text(currentEmoji)
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
//                    showLetter = true
                    if(count > 0) {
                        showingAlert = true
                    }
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
                       .foregroundColor(isCountingFinished ? Color("mainColor") : .gray)
                }
                .disabled(!isCountingFinished)
                
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
                        isCountingFinished = false
                        await dDayViewModel.loadRandomImage()
                        await dDayViewModel.countDay()
                        isCountingFinished = true
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
}

#Preview {
    DDayView()
        .environmentObject(DDayViewModel(cloudKitManager: CloudKitManager()))
}


