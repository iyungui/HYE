//
//  MentService.swift
//  HWYU
//
//  Created by 이융의 on 5/8/24.
//
/*
import Firebase
import FirebaseFirestore

class MentService: ObservableObject {
    @Published var ments: [Ment]
    private let dbCollection = Firestore.firestore().collection("Ment")
    private var listener: ListenerRegistration?
    
    init(ments: [Ment] = []) {
        self.ments = ments
        startRealtimeUpdates()
    }
    
    func fetch() {
        guard listener == nil else { return }
        dbCollection.getDocuments { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            print("Successfully fetched ments")
            updateMents(snapshot: snapshot)
        }
    }
    
    func addMent(text: String, created: Date, colorType: Ment.ColorType, completion: @escaping (Bool, String) -> Void) {
        Task {
            let id = UUID().uuidString
            let newMent: [String: Any] = [
                "id": id,
                "text": text,
                "created": Timestamp(date: created),
                "colorType": colorType.rawValue
            ]
            
            do {
                try await dbCollection.document(id).setData(newMent)
                fetch()
                DispatchQueue.main.async {
                    completion(true, "Success_addMent")
                }
            } catch {
                print("Error add ment: \(error)")
                DispatchQueue.main.async {
                    completion(false, "Error_addMent")
                }
            }
        }
    }

    private func startRealtimeUpdates() {
        listener = dbCollection.order(by: "created")
                                .addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self, let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(String(describing: error))")
                return
            }
            let changes = snapshot.documentChanges.filter { $0.type == .added }
            for change in changes {
                let document = change.document
                let id = document.documentID
                let text = document.get("text") as? String ?? ""
                let createdTimestamp = document.get("created") as? Timestamp
                let created = createdTimestamp?.dateValue() ?? Date()
                let colorTypeRaw = document.get("colorType") as? String ?? ""
                let colorType = Ment.ColorType(rawValue: colorTypeRaw) ?? .red

                let newMent = Ment(id: id, text: text, colorType: colorType, created: created, docId: id)
                DispatchQueue.main.async {
                    self.ments.insert(newMent, at: 0)
                }
            }
        }
    }

    
    private func updateMents(snapshot: QuerySnapshot) {
        let newMents: [Ment] = snapshot.documents.compactMap { document in
            var ment = try? document.data(as: Ment.self)
            ment?.docId = document.documentID
            return ment
        }
        DispatchQueue.main.async {
            self.ments = newMents
        }
    }


    func deleteMent(_ ment: Ment) {
        guard let docId = ment.docId else {
            print("Error: Ment does not have a valid document ID")
            return
        }
        
        dbCollection.document(docId).delete { [weak self] error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                DispatchQueue.main.async {
                    self?.ments.removeAll { $0.docId == docId }
                }
            }
        }
    }
}


*/
