//
//  ScreenLesgoViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 29/07/2023.
//

import UIKit

class ScreenLesgoViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        startButton.layer.cornerRadius = self.startButton.frame.height/2
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.borderWidth = 2
        navigationController?.isNavigationBarHidden = true
        draw()
    }
    
    func draw() {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let triangLayer: CAShapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: screenWidth/2, y: 0))
        path.addLine(to: CGPoint(x: screenWidth/2, y: (screenHeight/2) - 50))
        path.addLine(to: CGPoint(x: 0, y: screenHeight/2))
        triangLayer.fillColor = UIColor(hex: "#D32175")?.cgColor
        triangLayer.path = path.cgPath
        shapeLayer.insertSublayer(triangLayer, at: 0)
        myView.layer.addSublayer(shapeLayer)
        
        
        let shapeLayer1: CAShapeLayer = CAShapeLayer()
        let triangLayer1: CAShapeLayer = CAShapeLayer()
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: screenWidth/2, y: 0))
        path1.addLine(to: CGPoint(x: screenWidth, y: 0))
        path1.addLine(to: CGPoint(x: screenWidth, y: screenHeight/2))
        path1.addLine(to: CGPoint(x: screenWidth/2, y: (screenHeight/2) - 50))
        triangLayer1.fillColor = UIColor(hex: "#BC0F60")?.cgColor
        triangLayer1.path = path1.cgPath
        shapeLayer1.insertSublayer(triangLayer1, at: 0)
        myView.layer.addSublayer(shapeLayer1)
        
        
    }
    
    @IBAction func didTapStart(_ sender: UIButton) {
        UserDefaultService.shared.completedScrenn = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: LoginVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
    

}
