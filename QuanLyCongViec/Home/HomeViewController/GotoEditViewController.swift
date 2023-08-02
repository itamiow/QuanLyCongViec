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
    
    
    @IBOutlet weak var nameWorkTextField: UITextField!
    
    @IBOutlet weak var prioritizeView: UIView!
    @IBOutlet weak var prioritizeLabel: UILabel!
    @IBOutlet weak var prioritizeImage: UIImageView!
    
    @IBOutlet weak var remindView: UIView!
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var noteTexView: UITextView!
    var model: WorkItem?
    var models = [MyRemind]()
    
    let prioritizeDropdown = DropDown()
    let remindDropdown = DropDown()
    var dataPrioritize: [String] = ["Thấp", "Trung bình", "Cao"]
    var dataRemind: [String] = ["Không có nhắc nhỡ nào", "Báo trước 15p", "Báo trước 20p", "Báo trước 25p", "Báo trước 30p"]
    
    
    let dataStore = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let barButton = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(didTapbarbutton))
        navigationItem.rightBarButtonItem = barButton
      
        setupPrioritize()
        setupTime()
        config()
    }
    
    @objc func didTapbarbutton() {
        

        let namework = nameWorkTextField.text ?? ""
        let prioritize = prioritizeLabel.text ?? ""
        let remind = remindLabel.text ?? ""
        let note = noteTexView.text ?? ""
        let dateTime = datePickerView.date


        if namework.isEmpty || prioritize.isEmpty || remind.isEmpty || note.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Hãy nhập thông tin của bạn", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        } else {

            dataStore.collection("works").getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }else{
                    for document in querySnapshot!.documents {
                        if let documentId = document.data()["id"] as? String, let modelId = self.model?.id, documentId == modelId {
                            self.dataStore.collection("works").document(document.documentID).updateData(["name": namework,
                                                                                                         "prioritize": prioritize,
                                                                                                         "remind": remind,
                                                                                                         "note": note,
                                                                                                         "dateTime": dateTime,
                                                                                                         "id": modelId
                                                                                                        ])
                        }
                    }
                }
            })
        }

        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboar.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeVC, animated: true)
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
    
    
    
    func config() {
        nameWorkTextField.text = model?.name
        noteTexView.text = model?.note
        remindLabel.text = model?.remind.rawValue
        prioritizeLabel.text = model?.prioritize.rawValue
        
        let dateTime = model?.dateTime
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY at hh:mm"
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: "GTC + 7")
        datePickerView.date = model?.dateTime ?? Date()
    }
    
}
    
