//
//  ScreenLesgoViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 29/07/2023.
//

import UIKit

class ScreenLesgoViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var LesgoView: UIView!
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        LesgoView.layer.cornerRadius = 10
        LesgoView.layer.borderColor = UIColor.black.cgColor
        LesgoView.layer.borderWidth = 1
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
        
        
        
        let shapeLayer2: CAShapeLayer = CAShapeLayer()
        let triangLayer2: CAShapeLayer = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: screenWidth/2, y: 0))
        path2.addLine(to: CGPoint(x: screenWidth, y: 0))
        path2.addLine(to: CGPoint(x: screenWidth, y: screenHeight/2))
        path2.addLine(to: CGPoint(x: screenWidth/2, y: (screenHeight/2) - 50))
        triangLayer2.fillColor = UIColor(hex: "#BC0F60")?.cgColor
        triangLayer2.path = path2.cgPath
        shapeLayer2.insertSublayer(triangLayer2, at: 0)
        myView.layer.addSublayer(shapeLayer2)
        
        
    }
    
    @IBAction func didTapLesgo(_ sender: UIButton) {
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
