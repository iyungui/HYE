//
//  ContentView.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

struct Ment: Identifiable {
    let id: UUID = UUID()
    var text: String
}

extension Ment {
    static let sampleMent: [Ment] = [
        Ment(text: ""),
        Ment(text: "1. 너를 방울방울해"),
        Ment(text: "2. 혜원해"),
        Ment(text: "3. 계속 함께 있고 싶어"),
        Ment(text: "4. 넌 나의 봄날의 햇살같은 존재야"),
        Ment(text: "5. 날 좋아해줘서 고마워 나도 널 좋아하는 내가 좋아"),
        Ment(text: "6. 너는 내가 더 좋은 사람이고 싶게 만들어"),
        Ment(text: "7. 항상 내 옆에 있어줘서 고마워"),
        Ment(text: "8. 네가 어디에 있건 내가 찾아갈게"),
        Ment(text: "9. 너랑 아무 것도 안하고 있어도 난 행복해"),
        Ment(text: "10. 오늘도 수고했어 너무 잘 했어"),
        Ment(text: "11. 너 없으면 안 돼"),
        Ment(text: "12. 너는 나한테 꼭 필요한 사람이야"),
        Ment(text: "13. 네가 하는 모든 말은 나에게 너무 특별해"),
        Ment(text: "14. 너랑 보내는 시간이 너무 소중해"),
        Ment(text: "15. 다른 사람과 너를 비교할 수 없어"),
        Ment(text: "16. 너는 세상이 내게 준 가장 아름다운 선물이야"),
        Ment(text: "17. 후회하지 않도록 최선을 다할게"),
        Ment(text: "18. 진짜 사랑이 뭔지 알게 되었어"),
        Ment(text: "19. 너와 함께 할 미래가 궁금해졌어"),
        Ment(text: "20. 내 세상에 네가 들어온 건 축복이야"),
        Ment(text: "21. 네가 웃는 모습만 봐도 나는 기뻐"),
        Ment(text: "22. 소원 빌 때마다 우리가 영원히 함께하기를 빌어"),
        Ment(text: "23. 매일 밤 꿈에 네가 나왔으면 좋겠어"),
        Ment(text: "24. 첫눈에 반했다는 말을 믿게 됐어"),
        Ment(text: "25. 네가 원한다면 하늘의 별이라도 따줄게"),
        Ment(text: "26. 네가 행복하면 나도 행복해"),
        Ment(text: "27. 아무리 멀리 있어도 너는 항상 내 마음 가까이에 있어"),
        Ment(text: "28. 다시 태어난다면 너로 태어나서 나를 만나러 갈 거야"),
        Ment(text: "29. 너를 만난 것은 내 인생에서 가장 잘한 일이야"),
        Ment(text: "30. 보고 싶고 보고 싶고 또 보고 싶어"),
        Ment(text: "31. 너 없는 삶은 상상도 하기 싫어"),
        Ment(text: "32. 난 정말 운이 좋아, 너 같은 사람은 가졌다는 게"),
        Ment(text: "33. 내 품에 네가 안겼을 때 가장 행복하다고 느껴"),
        Ment(text: "34. '행운'이라는 단어가 너를 만난 후 나에게 의미가 있어졌어"),
        Ment(text: "35. 너의 눈동자에 내가 비춰지는 게 감사해"),
        Ment(text: "36. 변함없이 널 좋아해"),
        Ment(text: "37. 항상 내가 널 더 많이 좋아하고 있을 거야"),
        Ment(text: "38. 너는 항상 아름다움이 흘러 넘쳐"),
        Ment(text: "39. 이번 년도는 너무 후회되는 일 밖에 없는데, 딱 하나 잘 한 게 널 만난 거야"),
        Ment(text: "40. 언제나 네 옆에 내가 있어"),
        Ment(text: "41. 내 인생에 목표가 세 가지가 있는데, 첫 번째는 너랑 결혼하는 거야"),
        Ment(text: "42. 왜 이제 내 옆에 나타난 거야 기다렸잖아"),
        Ment(text: "43. 널 만나면서 내일이 항상 기대돼"),
        Ment(text: "44. 혜원이가 있으니까 구름도 더 이뻐보인다."),
        Ment(text: "45. 처음 만났을 때부터 지금도 그리고 앞으로도 네가 내 1순위야"),
        Ment(text: "46. 절대 변하지 않을게"),
        Ment(text: "47. 나보다 널 더 소중하게 생각해"),
        Ment(text: "48. 아무 이유 없이 보고 싶어")
    ]
}


let gradientBackground = LinearGradient(
    gradient: Gradient(colors: [
        Color(red: 0.96, green: 0.91, blue: 0.83), // 연한 베이지
        Color(red: 0.87, green: 0.94, blue: 0.88), // 연한 그린
        Color.white
    ]),
    startPoint: .top,
    endPoint: .bottom
)

struct ContentView: View {
    let sampleMent: [Ment] =  Ment.sampleMent
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 100) {
                ForEach(sampleMent) { ment in
                    AnimatedTextView(ment: ment)
                }
            }
            .padding()
        }
        .navigationTitle("혜원이에게")
        .toolbarBackground(gradientBackground, for: .navigationBar)
        .background(gradientBackground)
    }
}

struct AnimatedTextView: View {
    var ment: Ment
    
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

                .scaleEffect(scaleEffect)
                .opacity(opacityEffect)
                .frame(maxWidth: .infinity, alignment: .center)
                .animation(.easeInOut(duration: 0.5), value: scaleEffect)
                .animation(.easeInOut(duration: 0.5), value: opacityEffect)
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

