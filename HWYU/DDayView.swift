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
    
    func reload() {
        var newImage: String
        repeat {
            newImage = imageNames.randomElement() ?? "image01"
        } while newImage == currentImageName
        currentImageName = newImage
    }
    
    var body: some View {
        ZStack {
            Image(currentImageName)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .center) {
                HStack {
                    Text("혜원")
                    Button {
                        withAnimation {
                            reload()
                        }
                    } label: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.green)
                    }

                    Text("융의")
                }
                .padding(.vertical)
                .font(.headline)

                Spacer()

                HStack {
                    Text(formatDate(anniversaryDate))

                    Image(systemName: "heart.fill")
                        .foregroundColor(Color("mainColor"))
                    
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
        .onAppear {
            reload()
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
