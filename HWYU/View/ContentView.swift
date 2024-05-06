//
//  ContentView.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isUserAuthenticated {
            DDayView()
        } else {
            LoginView().environmentObject(authViewModel)
        }
    }
}
