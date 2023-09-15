//
//  ChangeNewPasswordViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
class ChangeNewPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var changeNewPasswordButton: UIButton!
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeNewPasswordButton.layer.cornerRadius = self.changeNewPasswordButton.frame.height/2
        changeNewPasswordButton.layer.borderWidth = 2
        changeNewPasswordButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func didTapChangeNewPassword(_ sender: UIButton) {
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        self.showLoading(isShow: true)
        if password.isEmpty || confirmPassword.isEmpty {
            let message = "Hãy nhập mật khẩu mới của bạn"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if password.isEmpty {
            let message = "Mật khẩu là cần thiết"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if password.count < 6 {
            let message = "Mật khẩu phải có ít nhất 6 kí tự"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if password.count > 40 {
            let message = "Mật khẩu không được quá 40 kí tự"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if confirmPassword.isEmpty {
            let message = "Nhập lại mật khẩu là cần thiết"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        
        
        let currentUser = Auth.auth().currentUser
            currentUser?.updatePassword(to: password) { error in
                if password != confirmPassword {
                    let message = "Mật khẩu không khớp"
                    self.showAlert(message: message)
                    self.showLoading(isShow: false)
                    return
                } else if error != nil {
                    print("failure")
                    self.showLoading(isShow: false)
                } else {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn đã đổi mật khẩu thành công", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                        self.confirmChange()
                        self.showLoading(isShow: false)
                    })
                    self.present(alert, animated: true, completion: nil)
                    print("success")
                }
            }
        }
    
    func confirmChange(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        navigationController?.pushViewController(userVC, animated: true)
    }
}
