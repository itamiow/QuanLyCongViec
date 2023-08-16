//
//  AuthService.swift
//  TutorialProject
//
//  Created by USER on 09/06/2023.
//

import Foundation
import KeychainSwift

class AuthService {
    
    static var share = AuthService()
    private var keychain: KeychainSwift
    
    private enum Keys: String {
        case kAccessToken
        case kRefreshToken
    }
    private init() {
        self.keychain = KeychainSwift()
    }
    
    var accessToken: String {
        get {
            return keychain.get(Keys.kAccessToken.rawValue) ?? ""
        } set {
            if newValue.isEmpty {
                keychain.delete(Keys.kAccessToken.rawValue)
            } else {
                keychain.set(newValue, forKey: Keys.kAccessToken.rawValue)
            }
        }
    }
    var isLoggedIn: Bool {
        return !accessToken.isEmpty
    }
    func clearAll() {
        accessToken = ""
    }
}
