//
//  ChangeNewPasswordViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit
import FirebaseAuth
class ChangeNewPasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var changeNewPasswordButton: UIButton!
    
    
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
  
        Auth.auth().currentUser?.updatePassword(to: password) { [weak self] error in
            guard let self = self else { return }
            if password.isEmpty || confirmPassword.isEmpty {
                let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập mật khẩu mới của bạn", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                })
                self.present(alert, animated: true)
                return
            } else {
                   let alert = UIAlertController(title: "Thông báo", message: "Bạn đã đổi mật khẩu thành công", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                       self.confirmChange()
                   })
                   self.present(alert, animated: true, completion: nil)
            }
        }
        validationOfTextFields()
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
}
    


