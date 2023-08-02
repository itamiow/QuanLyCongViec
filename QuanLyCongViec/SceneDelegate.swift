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
        let isCompletedScreen = UserDefaultService.shared.completedScrenn
        if isCompletedScreen {
            
            let islogin = AuthService.share.isLoggedIn
            if islogin {
                gotoHome()
            } else {
                routeLogin()
            }
        } else {
            routeScreen()
            }
            
           func routeScreen() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let screenVC = storyboard.instantiateViewController(withIdentifier: "ScreenSkipViewController")
                guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
                let nv = UINavigationController(rootViewController: screenVC)
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
            
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

