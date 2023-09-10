//
//  ForgotPasswordViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Quên mật khẩu"
        confirmButton.layer.cornerRadius = self.confirmButton.frame.height/2
        confirmButton.layer.borderColor = UIColor.white.cgColor
        confirmButton.layer.borderWidth = 2
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didTapConfirmChange(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        self.showLoading(isShow: true)
        Auth.auth().sendPasswordReset(withEmail: email) {[weak self] error in
            guard let self = self else { return }
            self.showLoading(isShow: false)
            if email.isEmpty {
                let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập email của bạn", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            guard error == nil else {
                let alert = UIAlertController(title: "Lỗi", message: "Email của bạn không đúng hoặc chưa được đăng ký", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            let alert = UIAlertController(title: "Vui lòng xác nhận", message: "1 thông báo đã được gửi đến email của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                AppDelegate.scene?.routeLogin()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}
