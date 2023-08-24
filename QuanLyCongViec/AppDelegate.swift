//
//  AppDelegate.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 19/07/2023.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        IQKeyboardManager.shared.keyboardAppearance = .default
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
        
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
}

