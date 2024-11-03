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

        // Vegetables
        Emoji(content: "🍅"), // Tomato
        Emoji(content: "🍆"), // Eggplant
        Emoji(content: "🥑"), // Avocado
        Emoji(content: "🥦"), // Broccoli
        Emoji(content: "🥒"), // Cucumber
        Emoji(content: "🌽"), // Corn
        Emoji(content: "🌶️"), // Hot Pepper
        Emoji(content: "🫑"), // Bell Pepper
        Emoji(content: "🥕"), // Carrot
        Emoji(content: "🧄"), // Garlic
        Emoji(content: "🧅"), // Onion
        Emoji(content: "🥔"), // Potato
        Emoji(content: "🍠"), // Sweet Potato
        Emoji(content: "🥬"), // Leafy Greens
        Emoji(content: "🍄"), // Mushroom

        // Protein and Meat
        Emoji(content: "🥩"), // Meat
        Emoji(content: "🍗"), // Poultry Leg
        Emoji(content: "🍖"), // Meat on Bone
        Emoji(content: "🥓"), // Bacon
        Emoji(content: "🍔"), // Burger
        Emoji(content: "🌭"), // Hot Dog
        Emoji(content: "🍤"), // Shrimp
        Emoji(content: "🍣"), // Sushi
        Emoji(content: "🍱"), // Bento Box
        Emoji(content: "🍙"), // Rice Ball
        Emoji(content: "🍚"), // Cooked Rice
        Emoji(content: "🥚"), // Egg
        Emoji(content: "🦪"), // Oyster

        // Dairy
        Emoji(content: "🧀"), // Cheese
        Emoji(content: "🥛"), // Glass of Milk
        Emoji(content: "🍦"), // Ice Cream
        Emoji(content: "🍨"), // Ice Cream Scoop
        Emoji(content: "🍧"), // Shaved Ice
        Emoji(content: "🍰"), // Cake
        Emoji(content: "🧁"), // Cupcake

        // Bread and Baked Goods
        Emoji(content: "🍞"), // Bread
        Emoji(content: "🥐"), // Croissant
        Emoji(content: "🥖"), // Baguette
        Emoji(content: "🥯"), // Bagel
        Emoji(content: "🥨"), // Pretzel
        Emoji(content: "🧇"), // Waffle
        Emoji(content: "🥞"), // Pancakes
        Emoji(content: "🍪"), // Cookie
        Emoji(content: "🍩"), // Donut
        Emoji(content: "🍯"), // Honey Pot

        // Drinks
        Emoji(content: "☕️"), // Coffee
        Emoji(content: "🧃"), // Juice Box
        Emoji(content: "🥤"), // Soft Drink
        Emoji(content: "🧋"), // Bubble Tea
        Emoji(content: "🍹"), // Tropical Drink
        Emoji(content: "🍸"), // Cocktail
        Emoji(content: "🍷"), // Wine
        Emoji(content: "🍺"), // Beer
        Emoji(content: "🍻"), // Beer Cheers

        // Sweets and Desserts
        Emoji(content: "🍫"), // Chocolate
        Emoji(content: "🍬"), // Candy
        Emoji(content: "🍭"), // Lollipop
        Emoji(content: "🍮"), // Custard
        Emoji(content: "🍡"), // Dango
        Emoji(content: "🥮"), // Mooncake
        Emoji(content: "🍢"), // Oden
        Emoji(content: "🍥"), // Fish Cake

        // Meals and Snacks
        Emoji(content: "🍕"), // Pizza
        Emoji(content: "🥪"), // Sandwich
        Emoji(content: "🌮"), // Taco
        Emoji(content: "🌯"), // Burrito
        Emoji(content: "🍜"), // Steaming Bowl
        Emoji(content: "🍝"), // Spaghetti
        Emoji(content: "🥘"), // Shallow Pan of Food
        Emoji(content: "🍲"), // Pot of Food
        Emoji(content: "🥗"), // Green Salad
        Emoji(content: "🍿"), // Popcorn

        // International Foods
        Emoji(content: "🥡"), // Takeout Box
        Emoji(content: "🍛"), // Curry Rice
        Emoji(content: "🍤"), // Tempura
        Emoji(content: "🍥"), // Narutomaki
        Emoji(content: "🥟"), // Dumpling
        Emoji(content: "🍜"), // Ramen
        Emoji(content: "🫔"), // Tamale
        Emoji(content: "🍱"), // Bento Box
        Emoji(content: "🍣"), // Sushi
    ]
}
