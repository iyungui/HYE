//
//  UiColorSet.swift
//  HWYU
//
//  Created by 이융의 on 1/7/24.
//

import Foundation
import SwiftUI

extension Color {
    static let primaryColor = Color("mainColor")
}

extension Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
}
