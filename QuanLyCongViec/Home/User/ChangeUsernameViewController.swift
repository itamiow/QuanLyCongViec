//
//  ChangeUsernameViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit
import FirebaseFirestore
class ChangeUsernameViewController: UIViewController {
    @IBOutlet weak var changeUserNameTextField: UITextField!
    @IBOutlet weak var changeUserNameButton: UIButton!
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUserNameButton.layer.cornerRadius = self.changeUserNameButton.frame.height/2
        changeUserNameButton.layer.borderWidth = 2
        changeUserNameButton.layer.borderColor = UIColor.white.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didTapChangeUsername(_ sender: UIButton) {
        let userName = changeUserNameTextField.text ?? ""
        guard let email = UserDefaultService.shared.currentEmail else { return }
        self.showLoading(isShow: true)
        if userName.isEmpty {
            let message = "Hãy nhập tên mới của bạn"
            showAlert(message: message)
            showLoading(isShow: false)
            return
        }
        if userName.count < 2 {
            let message = "Tên người dùng phải có ít nhất 2 kí tự"
            showAlert(message: message)
            return
        }
        if userName.count > 30 {
            let message = "Tên nguời dùng không được quá 30 kí tự"
            showAlert(message: message)
            return
        }
        
        if userName != nil {
            dataStore.collection("users")
                .document(email)
                .updateData(["usersName" : userName
                            ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                    }
                }
            let alert = UIAlertController(title: "Thông báo", message: "Bạn đã đổi tên thành công", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                self.confirmChange()
                self.showLoading(isShow: false)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    func confirmChange(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserViewController")
        navigationController?.pushViewController(userVC, animated: true)
    }
}
