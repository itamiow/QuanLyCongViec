//
//  ManagerWorkServices.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 23/07/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class WorkItem: Decodable {
    var id: String = ""
    var name: String = ""
    var prioritize: PrioritizeType = .none
    var remind: RemindType = .none
    var dateTime: Date?
    var note: String = ""
    var isCompletion: Bool?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case prioritize
        case remind
        case dateTime
        case note
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
       
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let rawPrioritize: String = (try? container.decode(String.self, forKey: .prioritize)) ?? ""
        prioritize = PrioritizeType(rawValue: rawPrioritize) ?? .none
        let remindRawValue = (try? container.decode(String.self, forKey: .remind)) ?? ""
        remind = RemindType(rawValue: remindRawValue) ?? .none
        let timeStamp = try? container.decode(Timestamp.self, forKey: .dateTime)
        dateTime = timeStamp?.dateValue()
        note = try container.decode(String.self, forKey: .note)
    }
    
}

extension WorkItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try? container.encode(prioritize.rawValue, forKey: .prioritize)
        try? container.encode(remind.rawValue, forKey: .remind)
        try? container.encode(dateTime, forKey: .dateTime)
        try container.encode(note, forKey: .note)
    }
}

enum PrioritizeType: String {
    case none = "Không có"
    case low = "Thấp"
    case medium = "Trung bình"
    case hight = "Cao"
}

enum RemindType: String {
    case none = "Không có nhắc nhỡ nào"
    case ten = "Báo trước 10p"
    case fifteen = "Báo trước 15p"
    case twenty = "Báo trước 20p"
    case twentyfive = "Báo trước 25p"
    case thirty = "Báo trước 30p"
}

protocol ManagerWorkProtocol {
    func login(email: String, password: String, completion: @escaping((Bool) -> Void))
    func register(username: String, email: String, password: String, confirmPassword: String, completion: @escaping ((Bool) -> Void))
    func resetPassword(email: String, completion: @escaping ((Bool) -> Void))
    
    func getListWork(completion: @escaping (([WorkItem]) -> Void))
    
    func deleteListWork(id: String, completion: @escaping ((Bool) -> Void))
   
}

final class ManagerWorkServices: ManagerWorkProtocol {
    static let shared: ManagerWorkProtocol = ManagerWorkServices()
    
    func login(email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func register(username: String, email: String, password: String, confirmPassword: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getListWork(completion: @escaping (([WorkItem]) -> Void)) {
        let dataStore = Firestore.firestore()
        dataStore.collection("works").getDocuments() { (querySnapshot, err) in
            var result: [WorkItem] = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let items = querySnapshot?.documents {
                    for item in items {
                        do {
                            let work: WorkItem = try item.data(as: WorkItem.self)
                            result.append(work)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            completion(result)
        }
    }
    
    func deleteListWork(id: String, completion: @escaping ((Bool) -> Void)) {
        let dataStore = Firestore.firestore()
        dataStore.collection("works").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(false)
            } else {
                print("Document successfully removed!")
                completion(true)
            }
        }
    }
 }
