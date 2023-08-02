//
//  ChangeUsernameViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 21/07/2023.
//

import UIKit

class ChangeUsernameViewController: UIViewController {

    @IBOutlet weak var changeUserNameTextField: UITextField!
    
    
    @IBOutlet weak var changeUsernameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        changeUsernameButton.layer.cornerRadius = 10
        changeUsernameButton.layer.borderWidth = 2
        changeUsernameButton.layer.borderColor = UIColor.white.cgColor
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didTapChangeUsername(_ sender: UIButton) {
    }
    
}
