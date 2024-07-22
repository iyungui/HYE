//
//  Letter.swift
//  HWYU
//
//  Created by Yungui Lee on 7/22/24.
//

import Foundation

struct Letter: Identifiable {
    let id = UUID()
    let date: String
    let name: String
}

extension Letter {
    static let letterList: [Letter] = [
        Letter(date: "2024-05-08", name: "혜원이")
    ]
}
