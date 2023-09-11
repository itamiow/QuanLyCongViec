//
//  HomeViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
class HomeViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    var listItem: [WorkItem] = []
    var model: WorkItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView.isHidden = true
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName:"ListWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "ListWorkTableViewCell")
        myTableView.reloadData()
        self.showLoading(isShow: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         fetchData()
    }
    
    private func fetchData() {
        ManagerWorkServices.shared.getListWork {[weak self] response in
            print(response)
            self?.listItem = response
            self?.myTableView.reloadData()
            self?.showLoading(isShow: false)
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.isHidden = !listItem.isEmpty
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listItem[indexPath.row]
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ListWorkTableViewCell", for: indexPath) as! ListWorkTableViewCell
        cell.configCell(item)
        cell.didTapEdit = {[weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            editVC.model = item
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        cell.checkbox = item.isComplete!
        cell.didTapCheckwork = {[weak self] in
            cell.checkbox = !cell.checkbox
            let dataStore = Firestore.firestore()
            let email = UserDefaultService.shared.currentEmail ?? ""
            dataStore.collection("users")
                .document(email)
                .collection("works")
                .document(item.id)
                .updateData(["isComplete" : cell.checkbox]) { error in
                print("update error \(error?.localizedDescription)")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        ManagerWorkServices.shared.deleteListWork(id: listItem[indexPath.row].id) {[weak self] status in
            if status {
                self?.fetchData()
                self?.showLoading(isShow: true)
            } else {
                let alert = UIAlertController(title: "Lỗi", message: "Xoá thất bại", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
   
}



