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
    let title: String
    var content: [String]
    
    init(date: String, name: String, fileName: String) {
        self.date = date
        self.title = name
        self.content = Letter.readTextFile(fileName: fileName)
    }
}

extension Letter {
    static let letterList: [Letter] = [
        Letter(date: "2024-05-08", name: "혜원이에게", fileName: "Letter_One.txt"),
        Letter(date: "2024-11-03", name: "너에게 보내는 두 번째 편지", fileName: "Letter_Two.txt")
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
}
