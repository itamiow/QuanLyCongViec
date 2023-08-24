//
//  RegisterViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = self.registerButton.frame.height/2
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func didTapRegister(_ sender: UIButton) {
        let userName = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if userName.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty {
            let message = "Hãy nhập thông tin đầy đủ"
            showAlert(message: message)
            return
        }
        if userName.isEmpty {
            let message = "Tên người dùng là cần thiết"
            showAlert(message: message)
            return
        }
        if userName.count < 2 {
            let message = "Tên người dùng phải có ít nhất 2 kí tự"
            showAlert(message: message)
            return
        }
        if userName.count > 30 {
            let message = "Tên nguời dùng không được quá 40 kí tự"
            showAlert(message: message)
            return
        }
        
        if email.isEmpty {
            let message = "Email là cần thiết"
            showAlert(message: message)
            return
        }
        if email.isEmpty || !emailPredicate.evaluate(with: email) {
            let message = "Định dạng email không hợp lệ"
            showAlert(message: message)
            return
        }
        
        if password.isEmpty {
            let message = "Mật khẩu là cần thiết"
            showAlert(message: message)
            return
        }
        if password.count < 4 {
            let message = "Mật khẩu phải có ít nhất 4 kí tự"
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
        
        handleRegister(userName: userName, email: email, password: password, confirmpassword: confirmPassword)
    }
    
    private func handleRegister(userName: String, email: String, password: String, confirmpassword: String) {
        registerButton.isEnabled = false
        registerButton.setTitle("Xin chờ...", for: .normal)
        if password != confirmpassword {
            self.validationOfTextFields()
            registerButton.isEnabled = true
            registerButton.setTitle("Đăng ký", for: .normal)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, err in
                guard let self = self else { return }
                self.registerButton.isEnabled = true
                self.registerButton.setTitle("Đăng ký", for: .normal)
                guard err == nil else {
                    var message = ""
                    switch AuthErrorCode.Code(rawValue: err!._code) {
                    case .emailAlreadyInUse:
                        message = "Email đã tồn tại"
                    case .invalidEmail:
                        message = "Email không hợp lệ"
                    default:
                        message = err?.localizedDescription ?? ""
                    }
                    let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                let showAlert = UIAlertController(title: "Thông báo", message: "Đăng ký thành công", preferredStyle: .alert)
                showAlert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                    self.gotoLogin()
                    self.handleData(userName: userName, email: email, password: password, confirmpassword: confirmpassword)
                })
                self.present(showAlert, animated: true)
            }
        }
    }
    
    func validationOfTextFields() -> Bool {
        var a = false
        if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Lỗi", message: "Mật khẩu không khớp", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            a = true
        }
        return a
    }
    
    func handleData(userName: String, email: String, password: String, confirmpassword: String) {
        dataStore.collection("users").document(email).setData([
            "usersName": userName,
            "email": email,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
            }
        }
    }
  
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    func gotoLogin() {
        AppDelegate.scene?.routeLogin()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
