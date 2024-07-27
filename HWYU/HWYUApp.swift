//
//  HWYUApp.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI

@main
struct HWYUApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ImageModel.self)
        }
    }
}
