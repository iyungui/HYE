//
//  DDayView.swift
//  HWYU
//
//  Created by 이융의 on 1/6/24.
//

import SwiftUI

struct DDayView: View {
    let anniversaryDate = Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 5))!
    let imageNames = ["image01", "image02", "image03", "image04", "image05", "image06", "image07"]

    var randomImageName: String {
        imageNames.randomElement() ?? "image01"
    }

    var body: some View {
        ZStack {
            Image(randomImageName)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()

            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .center) {
                HStack {
                    Text("혜원")
                    Image(systemName: "heart.fill")
                        .foregroundColor(.green)
                    Text("융의")
                }
                .padding(.vertical)
                .font(.headline)
                
                HStack(spacing: 15) {
                    NavigationLink(destination: WriteLetterView()) {
                        Image(systemName: "envelope")
                            .foregroundColor(Color.brown)
                    }
                    
                    NavigationLink(destination: LetterBoxView()) {
                        Image(systemName: "tray")
                            .foregroundColor(.teal)
                    }
                }
                .font(.title3)
                .fontWeight(.medium)

                Spacer()

                HStack {
                    Text(formatDate(anniversaryDate))

                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.primaryColor)
                    
                    Text("~")
                }
                .font(.headline)
                .foregroundColor(.white)

                Text(currentDateString())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)

                AnimatedDaysCountView(anniversaryDate: anniversaryDate)
            }
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden()
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct AnimatedDaysCountView: View {
    let anniversaryDate: Date
    @State private var currentDaysCount = 0

    var body: some View {
        HStack {
            Text("\(currentDaysCount)")
                .font(.largeTitle)
                .fontWeight(.black)
                .italic()
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5, x: 0, y: 0)
            Image(systemName: "arrowshape.up.fill")
                .foregroundColor(.white)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.003, repeats: true) { timer in
                if currentDaysCount < daysSinceAnniversary() {
                    currentDaysCount += 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    func daysSinceAnniversary() -> Int {
        let today = Date()
        guard today > anniversaryDate else { return 0 }

        let components = Calendar.current.dateComponents([.day], from: anniversaryDate, to: today)
        return components.day ?? 0
    }
}

#Preview {
    DDayView()
}
