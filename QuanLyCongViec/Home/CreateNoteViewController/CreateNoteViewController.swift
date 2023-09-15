//
//  CreateNoteViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import DropDown
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

class CreateNoteViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameWorkTextField: UITextField!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var colorPriorityView: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var noteTextView: UITextView!

    let priorityDropdown = DropDown()
    let remindDropdown = DropDown()
    var dataPriority: [String] = ["Không có","Thấp", "Trung bình", "Cao"]
    var dataRemind: [String] = ["Không có","Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priorityView.layer.cornerRadius = 5
        remindView.layer.cornerRadius = 5
        timeView.layer.cornerRadius = 5
        createButton.layer.cornerRadius = self.createButton.frame.height/2
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.borderWidth = 2
        noteTextView.layer.cornerRadius = 5
        colorPriorityView.layer.cornerRadius = self.colorPriorityView.frame.height/2
        colorPriorityView.backgroundColor = UIColor(hex: "E3EFFF")
        setupPriority()
        setupTime()
        
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
                self.priorityLabel.textColor = .lightGray
            } else if item == "Thấp" {
                self.colorPriorityView.backgroundColor = UIColor(hex: "0500FF")
            } else if item == "Trung bình" {
                self.colorPriorityView.backgroundColor = UIColor(hex: "FFF500")
            } else {
                self.colorPriorityView.backgroundColor = UIColor(hex: "FF0000")
            }
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
                self.remindLabel.textColor = .lightGray
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
    
    @IBAction func didTapCreate(_ sender: UIButton) {
        
        let namework = nameWorkTextField.text ?? ""
        let priority = priorityLabel.text ?? ""
        let remind = remindLabel.text ?? ""
        let note = noteTextView.text ?? ""
        let dateTime = datePickerView.date
        self.showLoading(isShow: true)
        let dataStore = Firestore.firestore()
        if namework.isEmpty || note.isEmpty {
            let message = "Hãy nhập thông tin của bạn"
            showAlert(message: message)
            return
            self.showLoading(isShow: false)
        } else {
            var ref: DocumentReference?
            let email = UserDefaultService.shared.currentEmail ?? ""
            ref = dataStore.collection("users")
                .document(email)
                .collection("works")
                .addDocument(data: ["name": namework,
                                    "priority": priority,
                                    "remind": remind,
                                    "note": note,
                                    "dateTime": dateTime,
                                    "isComplete": false
                                   ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    let documentId: String = ref?.documentID ?? ""
                    dataStore.collection("users")
                        .document(email)
                        .collection("works")
                        .document(documentId)
                        .updateData(["id": documentId]) {_ in
                    }
                }
            }
        }
        let alert = UIAlertController(title: "Thông báo", message: "Bạn đã tạo 1 công việc mới", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) {_ in
            self.showLoading(isShow: false)
            AppDelegate.scene?.routeToHome()
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
        setupRemind()
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

