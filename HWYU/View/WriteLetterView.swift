//
//  WriteLetterView.swift
//  HWYU
//
//  Created by 이융의 on 1/7/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct WriteLetterView: View {
    @State private var letterContent = ""
    @State private var partnerUser = ""  // 상대방 이메일을 입력받을 필드
    let currentUser: String  // 현재 로그인한 사용자의 이메일

    init() {
        // 현재 로그인한 사용자의 이메일 주소를 가져옵니다.
        currentUser = Auth.auth().currentUser?.email ?? ""
    }

    var body: some View {
        VStack {
            Text("편지 쓰기")
                .font(.headline)
                .padding()

            TextField("상대방 이메일", text: $partnerUser)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $letterContent)
                .frame(minHeight: 200)
                .border(Color.gray, width: 1)
                .padding()

            Button(action: sendLetter) {
                Text("편지 보내기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }

    func sendLetter() {
        let newLetter = Letter(sender: currentUser, recipient: partnerUser, content: letterContent, timestamp: Date())

        let letterDict = [
            "sender": newLetter.sender,
            "recipient": newLetter.recipient,
            "content": newLetter.content,
            "timestamp": newLetter.timestamp.timeIntervalSince1970
        ] as [String : Any]
        
        
        let dbRef = Database.database().reference()
        dbRef.child("letters").childByAutoId().setValue(letterDict) { error, _ in
            if let error = error {
                print("Error saving letter: \(error.localizedDescription)")
            } else {
                print("Letter successfully saved")
                // 여기에서 푸시 알림 보내기 로직을 추가할 수 있음
            }
        }
    }
}

struct WriteLetterView_Previews: PreviewProvider {
    static var previews: some View {
        WriteLetterView()
    }
}

