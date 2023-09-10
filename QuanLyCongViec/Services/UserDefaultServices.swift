//
//  UserDefaultServices.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/08/2023.
//

import Foundation

class UserDefaultService {
    
    static var shared = UserDefaultService()
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case Tutorial
        case kLoggedIn
        case emailUserKey
    }
    
    private init() {
        
    }

    var completedTutorial: Bool {
        get {
            return standard.bool(forKey: Keys.Tutorial.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.Tutorial.rawValue)
            standard.synchronize()
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return standard.bool(forKey: Keys.kLoggedIn.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.kLoggedIn.rawValue)
            standard.synchronize()
        }
    }
    
    var currentEmail: String? {
        get {
            return standard.string(forKey: Keys.emailUserKey.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.emailUserKey.rawValue)
        }
    }
    
    
    func clearAll() {
        standard.removeObject(forKey: Keys.Tutorial.rawValue)
        standard.removeObject(forKey: Keys.kLoggedIn.rawValue)
        standard.removeObject(forKey: Keys.emailUserKey.rawValue)
    }
    
}
