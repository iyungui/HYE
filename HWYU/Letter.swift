//
//  Letter.swift
//  HWYU
//
//  Created by 이융의 on 1/7/24.
//

import Foundation

struct Letter: Identifiable {
    var id: String?
    var sender: String
    var recipient: String
    var content: String
    var timestamp: Date
}
