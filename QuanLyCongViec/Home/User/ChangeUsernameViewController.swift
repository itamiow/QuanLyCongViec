//
//  ChangeUsernameViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ChangeUsernameViewController: UIViewController {
    @IBOutlet weak var changeUserNameTextField: UITextField!
    @IBOutlet weak var changeUsernameButton: UIButton!
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUsernameButton.layer.cornerRadius = self.changeUsernameButton.frame.height/2
        changeUsernameButton.layer.borderWidth = 2
        changeUsernameButton.layer.borderColor = UIColor.white.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didTapChangeUsername(_ sender: UIButton) {
        let userName = changeUserNameTextField.text ?? ""
        guard let email = UserDefaults.standard.currentEmail else { return }
        if userName.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập thông tin của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            })
            self.present(alert, animated: true)
            return
        } else {
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
            }
            let alert = UIAlertController(title: "Thông báo", message: "Bạn đã đổi tên thành công", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                self.confirmChange()
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
