//
//  LoginViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = self.loginButton.frame.height/2
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        navigationController?.isNavigationBarHidden = true
        emailTextField.text = "quangvien@gmail.com"
        passwordTexField.text = "123123"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func didTapRegister(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func didTapforgotPassword(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTexField.text ?? ""
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        showLoading(isShow: true)
        if email.isEmpty && password.isEmpty {
            let message = "Hãy nhập thông tin đầy đủ"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if email.isEmpty {
            let message = "Email là cần thiết"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        
        if email.isEmpty ||  !emailPredicate.evaluate(with: email) {
            let message = "Định dạng email là không hợp lệ"
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
            let message = "Mật khẩu ít nhất phải có 6 kí tự trở lên"
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
        handleLogin(email: email, password: password)
    }
    
    private func handleLogin(email: String, password: String) {
        self.showLoading(isShow: true)
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, err in
            self?.showLoading(isShow: false)
            guard let strongSelf = self else { return }
            guard err == nil else {
                var message = ""
                switch AuthErrorCode.Code(rawValue: err!._code) {
                case .wrongPassword:
                    message = "Mật khẩu chưa đúng! Vui lòng nhập lại"
                default:
                    message = "Email chưa đúng! Vui lòng nhập lại"
                }
                let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
                self?.showLoading(isShow: false)
                return
                
            }
            AppDelegate.scene?.routeToHome()
            UserDefaultService.shared.currentEmail = email
            UserDefaultService.shared.isLoggedIn = true
        }
    }
}
