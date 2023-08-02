//
//  ScreenSkipViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 29/07/2023.
//

import UIKit

class ScreenSkipViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var skipView: UIView!
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
        skipView.layer.cornerRadius = 10
        skipView.layer.borderColor = UIColor.black.cgColor
        skipView.layer.borderWidth = 1
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
        
        
        
        let shapeLayer2: CAShapeLayer = CAShapeLayer()
        let triangLayer2: CAShapeLayer = CAShapeLayer()
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: screenWidth/2, y: 0))
        path2.addLine(to: CGPoint(x: screenWidth, y: 0))
        path2.addLine(to: CGPoint(x: screenWidth, y: screenHeight/2))
        path2.addLine(to: CGPoint(x: screenWidth/2, y: (screenHeight/2) - 50))
        triangLayer2.fillColor = UIColor(hex: "#0B5F4F")?.cgColor
        triangLayer2.path = path2.cgPath
        shapeLayer2.insertSublayer(triangLayer2, at: 0)
        myView.layer.addSublayer(shapeLayer2)
    }
    
    
    @IBAction func didTapSkip(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let lesgoVC = storyboard.instantiateViewController(withIdentifier: "ScreenLesgoViewController") as! ScreenLesgoViewController
        navigationController?.pushViewController(lesgoVC, animated: true)
    }

}
