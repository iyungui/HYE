//
//  ImageModel.swift
//  HWYU
//
//  Created by Yungui Lee on 7/27/24.
//

import SwiftUI
import SwiftData

@Model
final class ImageModel: Identifiable {
    let id = UUID()
    let date = Date()
    @Attribute(.externalStorage) var imageData: Data?
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
