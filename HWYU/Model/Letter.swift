//
//  Letter.swift
//  HWYU
//
//  Created by Yungui Lee on 7/22/24.
//

import Foundation
import SwiftUI

struct Letter: Identifiable {
    let id = UUID()
    let date: String
    let title: String
    var content: [String]
    var images: [String]
    
    init(date: String, name: String, fileName: String, imagesStart: Int, imagesEnd: Int) {
        self.date = date
        self.title = name
        self.content = Letter.readTextFile(fileName: fileName)
        self.images = Letter.getImageName(start: imagesStart, end: imagesEnd)
    }
}

extension Letter {
    static let letterList: [Letter] = [
        Letter(date: "2024-05-08", name: "혜원이에게", fileName: "Letter_One.txt", imagesStart: 1, imagesEnd: 7),
        Letter(date: "2024-11-03", name: "너에게 보내는 두 번째 편지", fileName: "Letter_Two.txt", imagesStart: 8, imagesEnd: 21),
    ]
}

extension Letter {
    static func readTextFile(fileName: String) -> [String] {
        // 파일을 담을 변수 생성
        var result = ""
        var results: Array<String>
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("Error: file not found - \(fileName)")
            return []
        }
        
        do {
            result = try String(contentsOfFile: path, encoding: .utf8)
            results = result.components(separatedBy: "\n")
            return results
        } catch {
            print("Error: file read failed - \(error.localizedDescription)")
            return []
        }
    }
    static func getImageName(start: Int, end: Int) -> [String] {
        return (start...end).map { String(format: "image%02d", $0) }
    }
}


//struct ItemLetter: View {
//    var letter: Letter
//    
//    init(_ letter: Letter) {
//        self.letter = letter
//    }
//    
//    var body: some View {
//        Image(letter.content.first!)
//            .resizable()
//            .scaledToFill()
//            .frame(height: 500)
//    }
//}
