//
//  ImageDetailView.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import SwiftUI
import UIKit

struct ImageDetailView: View {
    let image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ImageDetailView(image: UIImage(imageLiteralResourceName: "image03"))
}
