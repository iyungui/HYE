//
//  LoginView.swift
//  HWYU
//
//  Created by 이융의 on 1/7/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var showingSignUpView: Bool = false
    @State private var showingDDayView: Bool = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: {
                signIn()
            }) {
                Text("로그인")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(4)
            }
            .padding()
            
            
            Button(action: {
                showingSignUpView = true
            }) {
                Text("회원가입")
            }
            
            NavigationLink(destination: DDayView(), isActive: $showingDDayView) {
                EmptyView()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showingSignUpView) {
            SignUpView(showingSignUpView: $showingSignUpView)
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 오류 처리
                self.errorMessage = error.localizedDescription
            } else {
                self.errorMessage = "success login"
                self.showingDDayView = true
                authViewModel.isUserAuthenticated = true
            }
        }
    }
}


struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message: String?
    @State private var showingAlert: Bool = false
    @Binding var showingSignUpView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingSignUpView = false
                }) {
                    Image(systemName: "chevron.backward")
                }
                Spacer()
            }
            .padding()
            
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = message {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                signUp()
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("알림"),
                message: Text(message ?? "회원가입에 성공하였습니다!"),
                dismissButton: .default(Text("확인")) {
                    self.showingSignUpView = false
                }
            )
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 오류 처리
                self.message = error.localizedDescription
                self.showingAlert = true
            } else {
                self.message = "회원가입에 성공하였습니다!"
                self.showingAlert = true
            }
        }
    }
}


#Preview {
    LoginView()
}
