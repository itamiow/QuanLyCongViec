//
//  NointernetViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 28/08/2023.
//

import UIKit
import Lottie
class NointernetViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retryButton.layer.cornerRadius = self.retryButton.frame.height/2
        
        animationView = .init(name: "noInternet")
        animationView!.frame = myView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.7
        myView.addSubview(animationView!)
        animationView!.play()
    }
    
    
    @IBAction func didTapRetry(_ sender: UIButton) {
        if NetworkMonitor.shared.isReachable {
            let isCompletedTutorial = UserDefaultService.shared.completedTutorial
            let isLoggedIn = UserDefaultService.shared.isLoggedIn
            
            //Kiểm tra xem người dùng đã hoàn thành Tutorial và check đăng nhập
            
                if isCompletedTutorial {
                if isLoggedIn {
                    AppDelegate.scene?.routeToHome()
                } else {
                    AppDelegate.scene?.routeLogin()
                }
            } else {
                AppDelegate.scene?.routeTutorial()
            }
        } else {
            return
        }
    }
}
