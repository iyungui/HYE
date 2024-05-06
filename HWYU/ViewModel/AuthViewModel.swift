//
//  AuthViewModel.swift
//  HWYU
//
//  Created by 이융의 on 1/7/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        addAuthStateListener()
    }

    private func addAuthStateListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.isUserAuthenticated = user != nil
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
