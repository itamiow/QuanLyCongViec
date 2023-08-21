//
//  UserDefault+Extension.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/08/2023.
//

import Foundation

enum UserDefaultKey {
    static let emailUserKey: String = "email_user_key"
}

extension UserDefaults {

    var currentEmail: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.emailUserKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.emailUserKey)
        }
    }
}
