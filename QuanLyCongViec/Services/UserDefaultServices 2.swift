//
//  UserDefaultServices.swift
//  TutorialProject
//
//  Created by USER on 09/06/2023.
//

import Foundation
import KeychainSwift


class UserDefaultService {
    
    static var shared = UserDefaultService()
    private var standard = UserDefaults.standard
    
    private enum Keys: String {
        case kCompletedScrenn
    }
    
    private init() {
        
    }

    var completedScrenn: Bool {
        get {
            return standard.bool(forKey: Keys.kCompletedScrenn.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.kCompletedScrenn.rawValue)
            standard.synchronize()
        }
    }
    func clearAll() {
        standard.removeObject(forKey: Keys.kCompletedScrenn.rawValue)
    }
    
}
