//
//  ChangeNewPasswordViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit
import FirebaseAuth
class ChangeNewPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var changeNewPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        changeNewPasswordButton.layer.cornerRadius = 10
        changeNewPasswordButton.layer.borderWidth = 2
        changeNewPasswordButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func didTapChangeNewPassword(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if email.isEmpty {
                let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập email của bạn", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default)
                alert.addAction(actionOK)
                self.present(alert, animated: true)
                return
            }
            guard error == nil else {
                let alert = UIAlertController(title: "Lỗi", message: "Email của bạn không đúng hoặc chưa được đăng ký", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default)
                alert.addAction(actionOK)
                self.present(alert, animated: true)
                return
            }
            let alert = UIAlertController(title: "Vui lòng xác nhận", message: "1 thông báo đã được gửi đến email của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                self.gotoLogin()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    func gotoLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: loginVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
    
}
    


