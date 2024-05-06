////
////  LetterBoxView.swift
////  HWYU
////
////  Created by 이융의 on 1/7/24.
////
//
//import SwiftUI
//import FirebaseDatabase
//import FirebaseAuth
//
//struct LetterBoxView: View {
//    let currentUser: String  // 현재 로그인한 사용자의 이메일
//
//    init() {
//        // 현재 로그인한 사용자의 이메일 주소를 가져옵니다.
//        currentUser = Auth.auth().currentUser?.email ?? ""
//    }
//    
//    var body: some View {
//        TabView {
//            LettersListView(currentUserEmail: currentUser, mode: .sentLetters)
//                .tabItem {
//                    Label("보낸 편지", systemImage: "paperplane.fill")
//                }
//
//            LettersListView(currentUserEmail: currentUser, mode: .receivedLetters)
//                .tabItem {
//                    Label("받은 편지", systemImage: "tray.fill")
//                }
//        }
//    }
//}
//
//
//#Preview {
//    LetterBoxView()
//}
//
//struct LettersListView: View {
//    @State private var letters = [Letter]()
//    let currentUserEmail: String
//    var mode: ViewMode  // 조회 모드: 내가 쓴 편지 또는 받은 편지
//
//    enum ViewMode {
//        case sentLetters
//        case receivedLetters
//    }
//
//    var body: some View {
//        List {
//            ForEach(letters, id: \.id) { letter in
//                VStack(alignment: .leading) {
//                    Text(letter.content)
//                        .font(.body)
//                    Text("보낸 시간: \(letter.timestamp, formatter: dateFormatter)")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .onAppear(perform: loadLetters)
//    }
//
//    func loadLetters() {
//        let dbRef = Database.database().reference().child("letters")
//        let query = mode == .sentLetters ? dbRef.queryOrdered(byChild: "sender").queryEqual(toValue: currentUserEmail) : dbRef.queryOrdered(byChild: "recipient").queryEqual(toValue: currentUserEmail)
//
//        query.observe(.value) { snapshot in
//            var newLetters = [Letter]()
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                   let dict = snapshot.value as? [String: AnyObject],
//                   let sender = dict["sender"] as? String,
//                   let recipient = dict["recipient"] as? String,
//                   let content = dict["content"] as? String,
//                   let timestamp = dict["timestamp"] as? TimeInterval {
//                    let letter = Letter(id: snapshot.key, sender: sender, recipient: recipient, content: content, timestamp: Date(timeIntervalSince1970: timestamp))
//                    newLetters.append(letter)
//                }
//            }
//            self.letters = newLetters
//        }
//    }
//}
//
//// 날짜 형식 지정을 위한 DateFormatter
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    return formatter
//}()
