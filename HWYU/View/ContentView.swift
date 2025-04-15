//
//  ContentView.swift
//  HWYU
//
//  Created by Yungui Lee on 1/29/25.
//

import SwiftUI

struct ContentView: View {
   @State private var isLaunch: Bool = true
   @StateObject private var dDayViewModel = DDayViewModel(cloudKitManager: CloudKitManager())
   
   var body: some View {
       if isLaunch {
           LaunchView()
               .task {
                   await dDayViewModel.loadRandomImage()
                   self.isLaunch = false
               }
       } else {
           DDayView().environmentObject(dDayViewModel)
       }
   }
}

#Preview {
    ContentView()
}
