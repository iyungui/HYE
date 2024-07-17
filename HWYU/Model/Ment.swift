//
//  Ment.swift
//  HWYU
//
//  Created by 이융의 on 5/8/24.
//

import Foundation

struct Ment: Identifiable, Codable, Hashable {
    let id: String
    var text: String
    var colorType: ColorType
    var created: Date
    var docId: String?

    enum ColorType: String, Codable, CaseIterable {
        case red, blue
    }
}



extension Ment {
    static let sampleMent: [Ment] = [
        Ment(id: UUID().uuidString, text: "", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "1. 너를 방울방울해", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "2. 혜원해", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "3. 계속 함께 있고 싶어", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "4. 넌 나의 봄날의 햇살같은 존재야", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "5. 날 좋아해줘서 고마워 나도 널 좋아하는 내가 좋아", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "6. 너는 내가 더 좋은 사람이고 싶게 만들어", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "7. 항상 내 옆에 있어줘서 고마워", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "8. 네가 어디에 있건 내가 찾아갈게", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "9. 너랑 아무 것도 안하고 있어도 난 행복해", colorType: .blue, created: Date()),
        Ment(id: UUID().uuidString, text: "10. 오늘도 수고했어 너무 잘 했어", colorType: .blue, created: Date())
    ]
}
