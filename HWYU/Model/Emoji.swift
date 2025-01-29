//
//  Emoji.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import Foundation

struct Emoji {
    let id = UUID()
    let content: String
}

extension Emoji {
    static let emojis: [Emoji] = [
        // Fruits
        Emoji(content: "🍎"), // Apple
        Emoji(content: "🍏"), // Green Apple
        Emoji(content: "🍊"), // Tangerine
        Emoji(content: "🍋"), // Lemon
        Emoji(content: "🍌"), // Banana
        Emoji(content: "🍉"), // Watermelon
        Emoji(content: "🍇"), // Grapes
        Emoji(content: "🍓"), // Strawberry
        Emoji(content: "🫐"), // Blueberries
        Emoji(content: "🍒"), // Cherries
        Emoji(content: "🍑"), // Peach
        Emoji(content: "🥭"), // Mango
        Emoji(content: "🍍"), // Pineapple
        Emoji(content: "🥥"), // Coconut
        Emoji(content: "🥝"), // Kiwi
    ]
}
