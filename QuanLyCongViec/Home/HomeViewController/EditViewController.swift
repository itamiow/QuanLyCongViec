//
//  GotoEditViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 22/07/2023.
//

import UIKit
import DropDown
import FirebaseFirestore

class EditViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameWorkTextField: UITextField!
    
    @IBOutlet weak var prioritizeView: UIView!
    @IBOutlet weak var prioritizeLabel: UILabel!
    @IBOutlet weak var colorPrioritizeView: UIView!
    
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var noteTexView: UITextView!
    
    var model: WorkItem?
    
    let prioritizeDropdown = DropDown()
    let remindDropdown = DropDown()
    var dataPrioritize: [String] = ["Thấp", "Trung bình", "Cao"]
    var dataRemind: [String] = ["Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        config()
        setupPrioritize()
        setupTime()
        saveButton.layer.cornerRadius = self.saveButton.frame.height/2
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.white.cgColor
        colorPrioritizeView.layer.cornerRadius = self.colorPrioritizeView.frame.height/2
        prioritizeView.layer.cornerRadius = 5
        remindView.layer.cornerRadius = 5
        dateView.layer.cornerRadius = 5
        noteTexView.layer.cornerRadius = 5
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let namework = nameWorkTextField.text ?? ""
        let prioritize = prioritizeLabel.text ?? ""
        let remind = remindLabel.text ?? ""
        let note = noteTexView.text ?? ""
        let dateTime = datePickerView.date
        
        let dataStore = Firestore.firestore()
        if namework.isEmpty || prioritize.isEmpty || remind.isEmpty || note.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập thông tin của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            dataStore.collection("works")
                .document(model?.id ?? "")
                .updateData(["name": namework,
                             "prioritize": prioritize,
                             "remind": remind,
                             "note": note,
                             "dateTime": dateTime]) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                     
                }
            }
        }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let gotoHomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        navigationController?.pushViewController(gotoHomeVC, animated: true)
//        gotoHomeVC.navigationItem.hidesBackButton = true
        AppDelegate.scene?.gotoHome()
        setupRemind()
    }
    
    func setupPrioritize() {
        prioritizeDropdown.separatorColor = .black
        prioritizeDropdown.cornerRadius = 10
        prioritizeDropdown.anchorView = prioritizeView
        prioritizeDropdown.dataSource = dataPrioritize
        prioritizeDropdown.bottomOffset = CGPoint(x: 0, y: (prioritizeDropdown.anchorView?.plainView.bounds.height)!)
        prioritizeDropdown.topOffset = CGPoint(x: 0, y: -(prioritizeDropdown.anchorView?.plainView.bounds.height)!)
        prioritizeDropdown.direction = .bottom
        prioritizeDropdown.selectionAction = { (index: Int, item: String) in
            self.prioritizeLabel.text = self.dataPrioritize[index]
            self.prioritizeLabel.textColor = .black
            if item == "Thấp" {
                self.colorPrioritizeView.backgroundColor = UIColor(hex: "0500FF")
            } else if item == "Trung bình" {
                self.colorPrioritizeView.backgroundColor = UIColor(hex: "FFF500")
            } else {
                self.colorPrioritizeView.backgroundColor = UIColor(hex: "FF0000")
            }
        }
        if prioritizeLabel.text == "Thấp" {
            self.colorPrioritizeView.backgroundColor = UIColor(hex: "0500FF")
        } else if prioritizeLabel.text == "Trung bình" {
            self.colorPrioritizeView.backgroundColor = UIColor(hex: "FFF500")
        } else {
            self.colorPrioritizeView.backgroundColor = UIColor(hex: "FF0000")
        }
    }
    
    func setupTime() {
        remindDropdown.separatorColor = .black
        remindDropdown.cornerRadius = 10
        remindDropdown.anchorView = remindView
        remindDropdown.dataSource = dataRemind
        remindDropdown.bottomOffset = CGPoint(x: 0, y: (remindDropdown.anchorView?.plainView.bounds.height)!)
        remindDropdown.topOffset = CGPoint(x: 0, y: -(remindDropdown.anchorView?.plainView.bounds.height)!)
        remindDropdown.direction = .bottom
        remindDropdown.selectionAction = { (index: Int, item: String) in
            self.remindLabel.text = self.dataRemind[index]
            self.remindLabel.textColor = .black
            if item == "Không có" {
                self.datePickerView.date = self.datePickerView.date
            }else if item == "Báo trước 15p" {
                self.datePickerView.date = Date().addingTimeInterval(900)
            } else if item == "Báo trước 20p" {
                self.datePickerView.date = Date().addingTimeInterval(1200)
            } else if item == "Báo trước 25p" {
                self.datePickerView.date = Date().addingTimeInterval(1500)
            } else if item == "Báo trước 30p" {
                self.datePickerView.date = Date().addingTimeInterval(1800)
            }
            self.setupRemind()
        }
    }
    
    @IBAction func didTapPrioritize(_ sender: UIButton) {
        prioritizeDropdown.show()
    }
    
    @IBAction func didTapleRemind(_ sender: UIButton) {
        remindDropdown.show()
    }
    
    func config() {
        nameWorkTextField.text = model?.name
        noteTexView.text = model?.note
        remindLabel.text = model?.remind.rawValue
        prioritizeLabel.text = model?.prioritize.rawValue
        datePickerView.date = model?.dateTime ?? Date()
    }
    
    func setupRemind() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                self.notifacation()
            } else if error != nil {
                print("error occured")
            }
        })
    }
    func notifacation() {
        let content = UNMutableNotificationContent()
        content.title = "Thông báo"
        content.sound = .default
        content.body = "Bạn có 1 nhắc nhở"
        DispatchQueue.main.async {
            let tagetDate = self.datePickerView.date
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tagetDate), repeats: false)
            let request = UNNotificationRequest(identifier: "Main", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error != nil {
                    print("something went wrong")
                }
            })
        }
    }
}
    
