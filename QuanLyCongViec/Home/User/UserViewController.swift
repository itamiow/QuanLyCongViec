//
//  UserViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import Photos
import FirebaseAuth

class UserViewController: UIViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.avatarImage.image = UIImage(named: "user")
        avatarImage.layer.cornerRadius = self.avatarImage.layer.bounds.height/2
        avatarImage.clipsToBounds = true
        cameraView.layer.cornerRadius = self.cameraView.layer.bounds.height/2
        view.layoutIfNeeded()
    }
    
    func setUp() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        userNameView.layer.cornerRadius = 10
        userNameView.layer.borderWidth = 1
        userNameView.layer.borderColor = UIColor.black.cgColor
        
        emailView.layer.cornerRadius = 10
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.black.cgColor
        emailView.alpha = 0.5
        
        changePasswordView.layer.cornerRadius = 10
        changePasswordView.layer.borderWidth = 1
        changePasswordView.layer.borderColor = UIColor.black.cgColor
        
        logoutView.layer.cornerRadius = 10
        logoutView.layer.borderWidth = 1
        logoutView.layer.borderColor = UIColor.black.cgColor
    }
    
    func openSetting() {
        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.open(settingUrl)
        }
    }
    @IBAction func didTapCamera(_ sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumsAction: UIAlertAction = UIAlertAction(title: "Albums", style: .default) {_ in PHPhotoLibrary.requestAuthorization(for: .addOnly) {status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.imagePicker.modalPresentationStyle = .popover
                    self.present(self.imagePicker, animated: true)
                }
            } else if status == .notDetermined {
                self.openSetting()
            } else if status == .denied {
                self.openSetting()
            } else if status == .restricted {
                self.openSetting()
            } else if status == .limited {
                self.openSetting()
            }
        }
    }
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) {_ in
            AVCaptureDevice.requestAccess(for: .video) {response in
                if response {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        DispatchQueue.main.async {
                            self.imagePicker.allowsEditing = false
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                            self.imagePicker.cameraCaptureMode = .photo
                            self.imagePicker.cameraDevice = .front
                            self.imagePicker.modalPresentationStyle = .fullScreen
                            self.present(self.imagePicker, animated: true)
                        }
                    } else {
                    }
                } else {
                    self.openSetting()
                }
            }
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
        }
        actionSheetController.addAction(albumsAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    @IBAction func didTapUsername(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changeUsernameVC = storyboard.instantiateViewController(withIdentifier: "ChangeUsernameViewController") as! ChangeUsernameViewController
        navigationController?.pushViewController(changeUsernameVC, animated: true)
    }
    
    @IBAction func didTapChangePassword(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changeNewPasswordVC = storyboard.instantiateViewController(withIdentifier: "ChangeNewPasswordViewController") as! ChangeNewPasswordViewController
        navigationController?.pushViewController(changeNewPasswordVC, animated: true)
    }
    
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            gotoLogin()
        } catch {
            print("Lỗi đăng xuất")
        }
        
    }
    func gotoLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoLoginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return}
        let nv = UINavigationController(rootViewController: gotoLoginVC)
        nv.setNavigationBarHidden(true, animated: true)
        window.rootViewController = nv
        window.makeKeyAndVisible()
    }
    
}
extension UserViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        self.avatarImage.image = selectedImage
        dismiss(animated: true)
    }
}
