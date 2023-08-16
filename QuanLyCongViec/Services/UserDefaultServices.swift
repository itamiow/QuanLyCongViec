//
//  UserDefaultServices.swift
//
//  Created by USER on 09/06/2023.
//

import Foundation
import KeychainSwift


class UserDefaultService {
    
    static var shared = UserDefaultService()
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case Tutorial
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
    
    func clearAll() {
        standard.removeObject(forKey: Keys.Tutorial.rawValue)
    }
    
}
