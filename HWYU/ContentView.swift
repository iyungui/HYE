//
//  ContentView.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

let gradientBackground = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.96, green: 0.91, blue: 0.83), // 연한 베이지
        Color(red: 0.87, green: 0.94, blue: 0.88), // 연한 그린
        Color.white
    ]),
    startPoint: .top,
    endPoint: .bottom
)

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

struct ContentView: View {
    @StateObject private var service: MentService = MentService()
    @State private var textInput: String = ""
    @State private var selectedColorType: Ment.ColorType = .red
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 100) {
                Text("")

                ForEach(service.ments) { ment in
                    AnimatedTextView(ment: ment, service: service)
                }
            }
            .padding()
            .task {
                service.fetch()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        service.addMent(text: textInput, created: Date(), colorType: .red) { success, message in
                            print(message)
                            if success {
                                textInput = ""
                            }
                        }
                    } label: {
                        Image(systemName: "heart")
                            .foregroundStyle(.pink)
                    }
                    Button {
                        service.addMent(text: textInput, created: Date(), colorType: .blue) { success, message in
                            print(message)
                            if success {
                                textInput = ""
                            }
                        }
                    } label: {
                        Image(systemName: "heart")
                    }
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    TextField("Enter some text", text: $textInput)
                        .limitInputLength(value: $textInput, length: 10)
                }

            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(gradientBackground, for: .navigationBar)
        .background(gradientBackground)
    }
}

struct AnimatedTextView: View {
    var ment: Ment
    var service: MentService?
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = UIScreen.main.bounds.height
            let centerY = screenHeight / 2
            let minY = geometry.frame(in: .global).minY
            let distanceToCenter = abs(minY - centerY)
            let scaleEffect = max(0.5, 1 - (distanceToCenter / screenHeight))
            let opacityEffect = max(0.0, 1 - (distanceToCenter / (screenHeight / 2)))
            
            Text(ment.text)
                .font(Font.custom("S-CoreDream-5Medium", size: 30))
                .foregroundStyle(colorForType(ment.colorType))
                .scaleEffect(scaleEffect)
                .opacity(opacityEffect)
                .frame(maxWidth: .infinity, alignment: .center)
                .animation(.easeInOut(duration: 0.5), value: scaleEffect)
                .animation(.easeInOut(duration: 0.5), value: opacityEffect)
                .contextMenu {
                    Button {
                        service?.deleteMent(ment)
                    } label: {
                        Label("삭제하기", systemImage: "trash")
                    }
                }
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
    }
    private func colorForType(_ type: Ment.ColorType) -> Color {
        switch type {
        case .red:
            return .pink
        case .blue:
            return .blue
        }
    }
}
 
#Preview {
    NavigationStack {
        ContentView()
    }
}

