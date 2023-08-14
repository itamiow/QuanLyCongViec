//
//  ScreenSkipViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 29/07/2023.
//

import UIKit

class ScreenSkipViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
        continueButton.layer.cornerRadius = self.continueButton.frame.height/2
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.layer.borderWidth = 2
    }
    
    func draw() {
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let triangLayer: CAShapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: screenWidth/2, y: 0))
        path.addLine(to: CGPoint(x: screenWidth/2, y: (screenHeight/2) - 50))
        path.addLine(to: CGPoint(x: 0, y: screenHeight/2))
        triangLayer.fillColor = UIColor(hex: "#226F60")?.cgColor
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
        triangLayer1.fillColor = UIColor(hex: "#0B5F4F")?.cgColor
        triangLayer1.path = path1.cgPath
        shapeLayer1.insertSublayer(triangLayer1, at: 0)
        myView.layer.addSublayer(shapeLayer1)
    }
    
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lesgoVC = storyboard.instantiateViewController(withIdentifier: "ScreenLesgoViewController") as! ScreenLesgoViewController
        navigationController?.pushViewController(lesgoVC, animated: true)
    }

}
