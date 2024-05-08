//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI

struct DDayView: View {
    let anniversaryDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    
    var imageNames: [String] {
        return (1...7).map { String(format: "image%02d", $0) }
    }

    @State var currentImageName: String = "image01"
    
    @State private var currentDaysCount = 0
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    private func reload() {
        var newImage: String
        repeat {
            newImage = imageNames.randomElement() ?? "image01"
        } while newImage == currentImageName
        currentImageName = newImage
    }
    
    private func recount() {
        currentDaysCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.003, repeats: true) { timer in
            if currentDaysCount < daysSinceAnniversary() {
                currentDaysCount += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    // Calculates the number of days since the anniversary
    private func daysSinceAnniversary() -> Int {
        let today = Date()
        guard today > anniversaryDate else { return 0 }

        let components = Calendar.current.dateComponents([.day], from: anniversaryDate, to: today)
        return components.day ?? 0
    }
    
    // Formats a date to "yyyy.MM.dd" format
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    // Returns the current date as a string in "yyyy-MM-dd" format
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    @State private var heartCount: Int = 0
    @State private var showEggView: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(currentImageName)
                    .resizable()
                    .scaledToFit()
                
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .center) {
                    HStack {
                        Text("혜원")
                            .font(Font.custom("S-CoreDream-5Medium", size: 17))
                        
                        Button {
                            reload()
                            recount()
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.title3)
                                .foregroundColor(.green)
                        }

                        Text("융의")
                            .font(Font.custom("S-CoreDream-5Medium", size: 17))
                    }
                    .padding(.vertical)
                    
                    HStack(spacing: 0) {
                        Button("우리") {
                            heartCount += 1
                            print(heartCount)
                        }
                        .simultaneousGesture(LongPressGesture(minimumDuration: 2).onEnded { _ in
                            showEggView = true
                        })
                        .font(Font.custom("S-CoreDream-5Medium", size: 14))
                        .foregroundStyle(.gray)
                        
                        Text("가 함께한 지 벌써 \(currentDaysCount)일!")
                            .font(Font.custom("S-CoreDream-5Medium", size: 14))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()

                    HStack {
                        Text(formatDate(anniversaryDate))

                        NavigationLink(destination: ContentView()) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color("mainColor"))
                        }
                        
                        Text("~")
                    }
                    .font(.headline)
                    .foregroundColor(.white)

                    Text(currentDateString())
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)

                    HStack {
                        Button {
                            heartCount = 0
                            withAnimation {
                                reload()
                                recount()
                            }
                        } label: {
                            Text("\(currentDaysCount)")
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
            .sheet(isPresented: $showEggView) {
                EggView(showEggView: $showEggView, heartCount: $heartCount)
            }
            .onAppear {
                reload()
                recount()
            }
            .onReceive(timer) { _ in
                withAnimation {
                    reload()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct EggView: View {
    @Binding var showEggView: Bool
    @Binding var heartCount: Int
    @State private var currentPage: Int = 0
    @State private var showTabView: Bool = false
    
    var body: some View {
        VStack {
            Button {
                showTabView.toggle()
            } label: {
                Text("혜원이에게")
                Text("2024-05-08")
            }
            .font(showTabView ? .caption2 : .footnote)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)
            .foregroundColor(showTabView ? Color.blue : Color.gray)

            if showTabView {
                TabView(selection: $currentPage) {
                    ForEach(0..<min(heartCount, letterText.count), id: \.self) { index in
                        LetterView(showEggView: $showEggView, index: index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .transition(.slide)
                .animation(.easeInOut, value: currentPage)
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        // 실제로 표시할 채워진 하트의 개수는 min(heartCount, letterText.count)
                        let filledHeartCount = min(heartCount, letterText.count)
                        
                        ForEach(0..<filledHeartCount, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .padding(4)
                        }
                        
                        // 나머지 하트의 개수는 전체 개수에서 채워진 하트 개수를 뺀 것
                        ForEach(0..<(letterText.count - filledHeartCount), id: \.self) { index in
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                                .padding(4)
                        }
                    }
                }
                .scrollIndicatorsFlash(onAppear: true)
                .frame(height: 100)

            }
        }
    }
}

let letterText: [String] = [
    "혜원이에게",
    "안녕 혜원아!! 나는 융의야. \n이번에는 조금 특별한 방식으로 편지를 쓰게 됐어.",
    "너가 아날로그 방식을 더 선호하는 걸 알지만, 이번에는 어쩔 수 없이 여기다가 쓰게 됐다!",
    "음 이렇게 한 문장씩 넘기면서 쓰는것도 꽤 괜찮은 것 같아. \n너도 그렇지?",
    "아무튼 이번엔 좀 더 다르게 써보려고 해. 혜원이에게 해주고 싶은 말을 꾹꾹 눌러서 여기에 담았어.",
    "혜원이가 없었던 지난 100일은 무척 빠르게 지나간 것 같으면서도, 너가 너무 보고 싶은 시간이었어!!",
    "정말 보고싶다 조혜원! \n사랑해 -!",
    "솔직하게 말하면,\n이 앱을 다시 만드는 게 이 편지를 쓰는 것보다 더 오래 걸리기는 했어.",
    "그렇지만 너랑 같이 사용할 수 있는 어플을 만들고 싶었어!",
    "맘에 들면 더 업데이트 해볼게!",
    "혜원아!",
    "한국오면\n맛있는 거 또 같이 먹으러 가자.",
    "사우나도 가고,",
    "찜질방도 가자!",
    "그리고 삼겹살도 먹고 만화카페도 가자",
    "그리고 나랑 같이 있자!! 알았지?",
    "(그래 그리고 마라탕이랑 마라로제도 먹자)",
    "혜원아! 사실 지금 내 심정은",
    "100일 기념이라고 너한테 새 편지를 줬을 때와 지금의 느낌이 많이 달라",
    "뭔가 여러가지 생각이 많이 들어! 너랑 떨어진 시간만큼 너도 이런저런 생각을 엄청 많이 했겠지?",
    "그니까 한국와서 못다한 얘기, 못다한 시간들, \n얼굴 보면서 우리 얘기하자-! \n진심.",
    "이야~~~~~",
    "그렇지만 내가 너한테 하고 싶은 말 하나만 뽑자면,",
    "뭐일 것 같아?",
    "사랑해!!",
    "이제는 \n🌑(달) 만큼도 아니라",
    "이제는 음..",
    "저기 있는. 🪐(목성) 만큼 더 사랑해!",
    "이제 너도 페이지를 더 넘기기 귀찮겠지?",
    "아무튼 조심히 한국에 오렴. 나는 여기 잘 있을게",
    "혜원이를 사랑하는\n이융의가."
]

struct LetterView: View {
    @Binding var showEggView: Bool
    var index: Int
    
    var images: [String] {
        return (1...7).map { String(format: "image%02d", $0) }
    }

    var body: some View {
        VStack {
            Image(images[index % images.count])
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Text(letterText[index % letterText.count])
                .font(.body)
                .padding()
            
            HStack {
                Spacer()
                Text("Page: \(index + 1) / \(letterText.count)")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding()
            }
            
            if index + 1 == letterText.count {
                Button("안녕!") {
                    showEggView = false
                }
            }
        }
        .padding()
    }
}

#Preview {
    EggView(showEggView: .constant(false), heartCount: .constant(7))
}



/*
 === S-CoreDream-1Thin
 === S-CoreDream-2ExtraLight
 === S-CoreDream-4Regular
 === S-CoreDream-3Light
 === S-CoreDream-5Medium
 === S-CoreDream-6Bold
 === S-CoreDream-7ExtraBold
 === S-CoreDream-8Heavy
 === S-CoreDream-9Black
 
 
//            for family: String in UIFont.familyNames {
//                            print(family)
//                            for names : String in UIFont.fontNames(forFamilyName: family){
//                                print("=== \(names)")
//                            }
//                        }
 */
