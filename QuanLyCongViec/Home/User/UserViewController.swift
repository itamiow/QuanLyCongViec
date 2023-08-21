//
//  UserViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import Photos
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
class UserViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var logoutView: UIView!
    let dataStore = Firestore.firestore()
    private var storage = Storage.storage().reference()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        handleData()
        print("😍 UserViewController viewDidLoad")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        avatarImage.layer.cornerRadius = self.avatarImage.layer.bounds.height/2
        avatarImage.clipsToBounds = true
        cameraView.layer.cornerRadius = self.cameraView.layer.bounds.height/2
        view.layoutIfNeeded()
        
        print("😍 UserViewController viewDidAppear")
        handleData()
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
        
        logoutView.backgroundColor = UIColor(hex: "E3EFFF")
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
                    self.imagePicker.allowsEditing = true
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
        let cancelAction: UIAlertAction = UIAlertAction(title: "Huỷ", style: .cancel) {_ in
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logout: UIAlertAction = UIAlertAction(title: "Đăng xuất", style: .destructive) {_ in
            do {
                try firebaseAuth.signOut()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                self.gotoLogin()
            } catch {
                print("Lỗi đăng xuất")
            }
        }
        let cancel: UIAlertAction = UIAlertAction(title: "Huỷ", style: .cancel) {_ in
        }
        alertController.addAction(logout)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
    }
    func gotoLogin(){
        AppDelegate.scene?.routeLogin()
    }
    
    func handleData() {
        guard let currentEmail = Auth.auth().currentUser?.email else {
            return
            
        }
        let docRef = self.dataStore.collection("users").document(currentEmail)
        
        docRef.getDocument { [weak self] snapshot, error in
            
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = snapshot?.data() {
                    print(data)
                    let email = data["email"] as? String
                    let userName = data["usersName"] as? String
                    let image = data["image"] as? String
                    
                    DispatchQueue.main.async {
                        strongSelf.emailLabel.text = email
                        strongSelf.userNameLabel.text = userName
                        if let image = image {
                            strongSelf.avatarImage.kf.setImage(with: URL(string: image))
                        }
                    }
                    
                }
            }
        }
    }
}
extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var urlString: String?
        
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("Error: \(info)")
            return
        }
        let resizeImage = resizeImage(image: selectedImage, targetSize: CGSize(width: 300, height: 300))
        guard let imageData = resizeImage.pngData() else {
            return
        }
        
        storage.child("images/userId.png").putData(imageData,metadata: nil, completion: { _,error in
            guard error == nil else {
                print("Failure to update")
                return
            }
        })
        
        storage.child("images/userId.png").downloadURL { url, error in
            guard let url = url, error == nil else {
                return
            }
            urlString = url.absoluteString
            print("Download \(urlString)")
            self.avatarImage.image = selectedImage
            
            //Lay email
            guard let currentEmail = Auth.auth().currentUser?.email else {return}
            
            //Update url vao firestore
            self.dataStore.collection("users").document(currentEmail).setData(["image": urlString], merge: true)
        }
        DispatchQueue.main.async {
            self.avatarImage.image = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
