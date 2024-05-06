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
    
    var body: some View {
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
                        withAnimation {
                            reload()
                            recount()
                        }
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundColor(.green)
                    }

                    Text("융의")
                        .font(Font.custom("S-CoreDream-5Medium", size: 17))
                }
                .padding(.vertical)
                
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

                HStack {
                    Text("\(currentDaysCount)")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .italic()
                    Image(systemName: "arrowshape.up.fill")
                }
                
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1, x: 1, y: 1)

            }
        }
        .onAppear {
            reload()
            recount()
        }
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    DDayView()
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
