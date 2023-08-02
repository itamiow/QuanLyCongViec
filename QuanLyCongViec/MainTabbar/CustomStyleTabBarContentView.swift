//
//  CustomStyleTabBarContentView.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import Foundation
import ESTabBarController_swift

class CustomStyleTabBarContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.black
        iconColor = UIColor.black
        highlightTextColor = UIColor.systemIndigo
        highlightIconColor = UIColor.systemIndigo
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
