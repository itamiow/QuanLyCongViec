//
//  SceneDelegate.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 19/07/2023.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScenen = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScenen)
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        let isCompletedTutorial = UserDefaultService.shared.completedTutorial
        if isCompletedTutorial {
            let islogin = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if islogin {
                gotoHome()
            } else {
                routeLogin()
            }
        } else {
            routeTutorial()
            }
            
    }
    
   func routeTutorial() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: tutorialVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
   func routeLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginlVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let navi = UINavigationController(rootViewController: LoginlVC)
        navi.setNavigationBarHidden(true, animated: true)
        window.rootViewController = navi
        window.makeKeyAndVisible()
    }
    func gotoHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoHomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nav = UINavigationController(rootViewController: gotoHomeVC)
        nav.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

