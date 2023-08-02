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
struct Prioritize {
    var image: String
    var title: String
}

struct MyRemind {
    var title: String
    var body: String
    var date: Date
}
class CreateNoteViewController: UIViewController {
    
    @IBOutlet weak var createNoteButton: UIButton!
    @IBOutlet weak var nameWorkTextField: UITextField!
    
    @IBOutlet weak var prioritizeView: UIView!
    @IBOutlet weak var prioritizeImage: UIImageView!
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
    var dataRemind: [String] = ["Không có nhắc nhỡ nào", "Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prioritizeView.layer.cornerRadius = 5
        remindView.layer.cornerRadius = 5
        timeView.layer.cornerRadius = 5
        
        createNoteButton.layer.cornerRadius = 10
        createNoteButton.layer.borderColor = UIColor.black.cgColor
        createNoteButton.layer.borderWidth = 1
        timeView.layer.cornerRadius = 5
        noteTextView.layer.cornerRadius = 5
        
        setupPrioritize()
        setupTime()
    }
    
    func setupPrioritize() {
        prioritizeDropdown.anchorView = prioritizeView
        prioritizeDropdown.dataSource = dataPrioritize
        prioritizeDropdown.bottomOffset = CGPoint(x: 0, y: (prioritizeDropdown.anchorView?.plainView.bounds.height)!)
        prioritizeDropdown.topOffset = CGPoint(x: 0, y: -(prioritizeDropdown.anchorView?.plainView.bounds.height)!)
        prioritizeDropdown.direction = .bottom
        prioritizeDropdown.selectionAction = { (index: Int, item: String) in
            self.prioritizeLabel.text = self.dataPrioritize[index]
            self.prioritizeLabel.textColor = .black
            if item == "Thấp" {
                self.prioritizeImage.image = UIImage(named: "orengi")
            } else if item == "Trung bình" {
                self.prioritizeImage.image = UIImage(named: "green")
            } else {
                self.prioritizeImage.image = UIImage(named: "red")
            }
        }
    }
    
    func setupTime() {
        remindDropdown.anchorView = remindView
        remindDropdown.dataSource = dataRemind
        remindDropdown.bottomOffset = CGPoint(x: 0, y: (remindDropdown.anchorView?.plainView.bounds.height)!)
        remindDropdown.topOffset = CGPoint(x: 0, y: -(remindDropdown.anchorView?.plainView.bounds.height)!)
        remindDropdown.direction = .bottom
        remindDropdown.selectionAction = { (index: Int, item: String) in
            self.remindLabel.text = self.dataRemind[index]
            self.remindLabel.textColor = .black
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
            let actionOK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        } else {
            var ref: DocumentReference?
            ref = dataStore.collection("works").addDocument(data: ["name": namework,
                                                             "prioritize": prioritize,
                                                             "remind": remind,
                                                             "note": note,
                                                             "dateTime": dateTime,
                                                                   "id": UUID().uuidString
                                                            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
//                    let documentId: String = ref?.documentID ?? ""
//                    dataStore.collection("works").document(documentId).updateData(["id": documentId]) { _ in
//
//                    }
//                    
                }
            }
        }
        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyboar.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
        navigationController?.pushViewController(nvc, animated: true)
    }
 
}

