//
//  SplashView.swift
//  HWYU
//
//  Created by Yungui Lee on 11/3/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }
    }
}

#Preview {
    SplashView()
}
