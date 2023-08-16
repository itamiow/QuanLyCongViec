//
//  LoginViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var yourEmailTextField: UITextField!
    @IBOutlet weak var yourPasswordTexField: UITextField!
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = self.loginButton.frame.height/2
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.white.cgColor
        navigationController?.isNavigationBarHidden = true
        yourEmailTextField.text = "quangvien@gmail.com"
        yourPasswordTexField.text = "123123"
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
        let email = yourEmailTextField.text ?? ""
        let password = yourPasswordTexField.text ?? ""
       
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty && password.isEmpty {
            let message = "Hãy nhập thông tin đầy đủ"
            showAlert(message: message)
            return
        }
        if email.isEmpty {
            let message = "Email là cần thiết"
            showAlert(message: message)
            return
        }
        
        if email.isEmpty ||  !emailPredicate.evaluate(with: email) {
            let message = "Định dạng email là không hợp lệ"
            showAlert(message: message)
            return
        }
        
        if password.isEmpty {
            let message = "Password là cần thiết"
            showAlert(message: message)
            return
        }
        if password.count < 4 {
            let message = "Password ít nhất phải có 4 kí tự trở lên"
            showAlert(message: message)
            return
        }
        
        if password.count > 40 {
            let message = "Password không được quá 40 kí tự"
            showAlert(message: message)
            return
        }
        handleLogin(email: email, password: password)
    }
    
    private func handleLogin(email: String, password: String) {
        loginButton.isEnabled = false
        loginButton.setTitle("Xin chờ...", for: .normal)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, err in
            guard let self = self else { return }
            self.loginButton.isEnabled = true
            self.loginButton.setTitle("Đăng nhập", for: .normal)
            guard err == nil else {
                var message = ""
                switch AuthErrorCode.Code(rawValue: err!._code) {
                default:
                    message = "Email hoặc mật khẩu chưa đúng"
                }
                let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            let showAlert = UIAlertController(title: nil, message: "Đăng nhập thành công", preferredStyle: .alert)
            showAlert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                self.gotoHome()
            })
            self.present(showAlert, animated: true)
        }
    }
  
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Thông báo!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoHomeVC = storyboard.instantiateViewController(withIdentifier: "MainTabbarViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: gotoHomeVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
}
