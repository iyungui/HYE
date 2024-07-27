//
//  ImageModel.swift
//  HWYU
//
//  Created by Yungui Lee on 7/27/24.
//

import SwiftUI
import SwiftData

@Model
class ImageModel: Identifiable {
    let id = UUID()
    @Attribute(.externalStorage) var imageData: Data?
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
