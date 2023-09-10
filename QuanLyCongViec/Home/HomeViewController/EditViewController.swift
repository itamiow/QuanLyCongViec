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
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var colorPriorityView: UIView!
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var noteTexView: UITextView!
    
    var model: WorkItem?
    
    let priorityDropdown = DropDown()
    let remindDropdown = DropDown()
    var dataPriority: [String] = ["Không có","Thấp", "Trung bình", "Cao"]
    var dataRemind: [String] = ["Không có","Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        config()
        setupPriority()
        setupTime()
        saveButton.layer.cornerRadius = self.saveButton.frame.height/2
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.white.cgColor
        colorPriorityView.layer.cornerRadius = self.colorPriorityView.frame.height/2
        priorityView.layer.cornerRadius = 5
        remindView.layer.cornerRadius = 5
        dateView.layer.cornerRadius = 5
        noteTexView.layer.cornerRadius = 5
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let namework = nameWorkTextField.text ?? ""
        let priority = priorityLabel.text ?? ""
        let remind = remindLabel.text ?? ""
        let note = noteTexView.text ?? ""
        let dateTime = datePickerView.date
        
        let dataStore = Firestore.firestore()
        if namework.isEmpty || priority.isEmpty || remind.isEmpty || note.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập thông tin của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let email = UserDefaultService.shared.currentEmail ?? ""
            dataStore.collection("users")
                .document(email)
                .collection("works")
                .document(model?.id ?? "")
                .updateData(["name": namework,
                             "priority": priority,
                             "remind": remind,
                             "note": note,
                             "dateTime": dateTime]) { error in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                     
                }
            }
        }
        AppDelegate.scene?.routeToHome()
        setupRemind()
    }
    
    func setupPriority() {
        priorityDropdown.separatorColor = .black
        priorityDropdown.cornerRadius = 10
        priorityDropdown.anchorView = priorityView
        priorityDropdown.dataSource = dataPriority
        priorityDropdown.bottomOffset = CGPoint(x: 0, y: (priorityDropdown.anchorView?.plainView.bounds.height)!)
        priorityDropdown.topOffset = CGPoint(x: 0, y: -(priorityDropdown.anchorView?.plainView.bounds.height)!)
        priorityDropdown.direction = .bottom
        priorityDropdown.selectionAction = { (index: Int, item: String) in
            self.priorityLabel.text = self.dataPriority[index]
            self.priorityLabel.textColor = .black
            if item == "Không có" {
                self.colorPriorityView.backgroundColor = UIColor(hex: "E3EFFF")
            } else if item == "Thấp" {
                self.colorPriorityView.backgroundColor = UIColor(hex: "0500FF")
            } else if item == "Trung bình" {
                self.colorPriorityView.backgroundColor = UIColor(hex: "FFF500")
            } else {
                self.colorPriorityView.backgroundColor = UIColor(hex: "FF0000")
            }
        }
        if priorityLabel.text == "Không có" {
            self.colorPriorityView.backgroundColor = UIColor(hex: "E3EFFF")
        } else if priorityLabel.text == "Thấp" {
            self.colorPriorityView.backgroundColor = UIColor(hex: "0500FF")
        } else if priorityLabel.text == "Trung bình" {
            self.colorPriorityView.backgroundColor = UIColor(hex: "FFF500")
        } else {
            self.colorPriorityView.backgroundColor = UIColor(hex: "FF0000")
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
                self.datePickerView.date = Date().addingTimeInterval(0)
            } else if item == "Báo trước 15p" {
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
    
    @IBAction func didTapPriority(_ sender: UIButton) {
        priorityDropdown.show()
    }
    
    @IBAction func didTapleRemind(_ sender: UIButton) {
        remindDropdown.show()
    }
    
    func config() {
        nameWorkTextField.text = model?.name
        noteTexView.text = model?.note
        remindLabel.text = model?.remind.rawValue
        priorityLabel.text = model?.priority.rawValue
        datePickerView.date = model?.dateTime ?? Date()
    }
    
    func setupRemind() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                self.notification()
            } else if error != nil {
                print("error occured")
            }
        })
    }
    func notification() {
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
    
