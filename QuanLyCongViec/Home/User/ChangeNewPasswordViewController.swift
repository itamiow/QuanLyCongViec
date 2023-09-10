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
        if password.isEmpty || confirmPassword.isEmpty {
            let message = "Hãy nhập mật khẩu mới của bạn"
            showAlert(message: message)
            return
        }
        if password.isEmpty {
            let message = "Mật khẩu là cần thiết"
            showAlert(message: message)
            return
        }
        if password.count < 6 {
            let message = "Mật khẩu phải có ít nhất 6 kí tự"
            showAlert(message: message)
            return
        }
        if password.count > 40 {
            let message = "Mật khẩu không được quá 40 kí tự"
            showAlert(message: message)
            return
        }
        if confirmPassword.isEmpty {
            let message = "Nhập lại mật khẩu là cần thiết"
            showAlert(message: message)
            return
        }
        
        self.validationOfTextFields()
        let currentUser = Auth.auth().currentUser
            currentUser?.updatePassword(to: password) { error in
                if let error = error {
                    print("failure")
                } else {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn đã đổi mật khẩu thành công", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                        self.confirmChange()
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
    
    func validationOfTextFields() -> Bool {
        var a = false
        if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Lỗi", message: "Mật khẩu không khớp", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            a = true
        }
        return a
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông Báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
