//
//  ShowLoading+Extension.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 07/09/2023.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    func showLoading(isShow: Bool) {
        if isShow {
           let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.progress = Float.random(in: 0...1)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
