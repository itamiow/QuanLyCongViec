//
//  extension + UIcolor.swift
//  BMIViewController
//
//  Created by USER on 19/05/2023.
//

import Foundation
import UIKit
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var rVal: CGFloat = 0.0
        var gVal: CGFloat = 0.0
        var bVal: CGFloat = 0.0
        var aVal: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            rVal = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            gVal = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            bVal = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            rVal = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            gVal = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            bVal = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            aVal = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: rVal, green: gVal, blue: bVal, alpha: aVal)
    }
}
