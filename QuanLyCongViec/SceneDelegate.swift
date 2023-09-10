//
//  SceneDelegate.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 19/07/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScenen = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScenen)
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        let isCompletedTutorial = UserDefaultService.shared.completedTutorial
        let isLoggedIn = UserDefaultService.shared.isLoggedIn
        let isReachableConnection = NetworkMonitor.shared.isReachable
        
        guard isReachableConnection else {
            routeToNoInternet()
            return
        }
        if isCompletedTutorial {
            if isLoggedIn {
                routeToHome()
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
        let nv = UINavigationController(rootViewController: LoginlVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
    func routeToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoHomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: gotoHomeVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
    func routeToNoInternet() {
        let noInternetAccessVC = NointernetViewController(nibName: "NointernetViewController", bundle: nil)
        let nv = UINavigationController(rootViewController: noInternetAccessVC)
        window?.rootViewController = nv
        window?.makeKeyAndVisible()
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

