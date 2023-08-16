//
//  ScreenLetsgoViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 29/07/2023.
//

import UIKit
import Lottie
class ScreenLetsgoViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView = .init(name: "animation")
        animationView!.frame = myView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.7
        myView.addSubview(animationView!)
        animationView!.play()
        
        myView.layer.cornerRadius = 10
        myView.backgroundColor = UIColor(hex: "E3EFFF")
        hideView.layer.cornerRadius = 10
        hideView.backgroundColor = UIColor(hex: "E3EFFF")
        
        startButton.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hex: "E3EFFF")
        
    }
    

    @IBAction func didTapStartButton(_ sender: UIButton) {
        UserDefaultService.shared.completedTutorial = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let letsgoVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(letsgoVC, animated: true)
    }
}
