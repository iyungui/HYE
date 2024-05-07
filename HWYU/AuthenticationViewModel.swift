//
//  AuthenticationViewModel.swift
//  HWYU
//
//  Created by 이융의 on 5/6/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices
import _PhotosUI_SwiftUI

extension UIApplication {
    static var currentRootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow })
            .first?
            .rootViewController
    }
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    enum State {
        case busy
        case signedIn
        case signedOut
    }
    
    @Published var errorMessage: String? = nil
    
    @Published var state: State = .busy
    private var authResult: AuthDataResult? = nil
    var username: String { authResult?.user.displayName ?? "" }
    var email: String { authResult?.user.email ?? "" }
    var photoURL: URL? { authResult?.user.photoURL }
    var userId: String { authResult?.user.uid ?? "" }
    
    //    func logout() {
    //        GIDSignIn.sharedInstance.signOut()
    //        GIDSignIn.sharedInstance.disconnect()
    //        try? Auth.auth().signOut()
    //        authResult = nil
    //        state = .signedOut
    //    }
    
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error { print("Error: \(error.localizedDescription)")}
            Task {
                await self.signIn(user: user)
            }
        }
    }
    
    func login() {
        state = .busy
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let rootViewController = UIApplication.currentRootViewController else {
            errorMessage = "Configuration error: Missing client ID or rootViewController"
            return
        }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: nil) { result, error in
            if let error {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                return
            }
            Task {
                await self.signIn(user: result?.user)
                
            }
        }
    }
    func performAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
    }
    
    func signIn(user: GIDGoogleUser?) async {
        guard let user, let idToken = user.idToken else {
            errorMessage = "Login failed: Invalid user data"
            state = .signedOut
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
        
        do {
            authResult = try await Auth.auth().signIn(with: credential)
            state = .signedIn
            print(state)
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
            state = .signedOut
        }
    }
}
