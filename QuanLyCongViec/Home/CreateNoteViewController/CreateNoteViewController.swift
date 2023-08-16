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

struct MyRemind {
    var title: String
    var body: String
    var date: Date
}
class CreateNoteViewController: UIViewController {
    
    @IBOutlet weak var createNoteButton: UIButton!
    @IBOutlet weak var nameWorkTextField: UITextField!
    
    @IBOutlet weak var prioritizeView: UIView!
    @IBOutlet weak var colorPrioritizeView: UIView!
    @IBOutlet weak var prioritizeLabel: UILabel!
    
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var models = [MyRemind]()
    
    let prioritizeDropdown = DropDown()
    let remindDropdown = DropDown()
    var dataPrioritize: [String] = ["Thấp", "Trung bình", "Cao"]
    var dataRemind: [String] = ["Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prioritizeView.layer.cornerRadius = 5
        remindView.layer.cornerRadius = 5
        timeView.layer.cornerRadius = 5
        
        createNoteButton.layer.cornerRadius = self.createNoteButton.frame.height/2
        createNoteButton.layer.borderColor = UIColor.white.cgColor
        createNoteButton.layer.borderWidth = 2
        timeView.layer.cornerRadius = 5
        noteTextView.layer.cornerRadius = 5
        
        colorPrioritizeView.layer.cornerRadius = self.colorPrioritizeView.frame.height/2
        colorPrioritizeView.backgroundColor = UIColor(hex: "E3EFFF")
        
       
        setupPrioritize()
        setupTime()
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
    
    
    @IBAction func didTapCreate(_ sender: UIButton) {
        
        let namework = nameWorkTextField.text ?? ""
        let prioritize = prioritizeLabel.text ?? ""
        let remind = remindLabel.text ?? ""
        let note = noteTextView.text ?? ""
        let dateTime = datePickerView.date
        
        let dataStore = Firestore.firestore()
        if namework.isEmpty || prioritize.isEmpty || remind.isEmpty || note.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập thông tin của bạn", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            var ref: DocumentReference?
            ref = dataStore.collection("works").addDocument(data: ["name": namework,
                                                                   "prioritize": prioritize,
                                                                   "remind": remind,
                                                                   "note": note,
                                                                   "dateTime": dateTime
                                                                  ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    let documentId: String = ref?.documentID ?? ""
                    dataStore.collection("works").document(documentId).updateData(["id": documentId]) { _ in
                    }
                }
            }
        }
        let alert = UIAlertController(title: "Thông báo", message: "Bạn đã tạo 1 công việc mới, vui lòng chuyển sang mục công việc để xem", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) {_ in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
//            self.navigationController?.pushViewController(vc, animated: true)
            AppDelegate.scene?.gotoHome()
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
        setupRemind()
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

