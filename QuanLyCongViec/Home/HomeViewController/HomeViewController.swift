//
//  HomeViewController.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit
import Foundation
import FirebaseFirestore
class HomeViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var listItem: [WorkItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName:"ListWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "ListWorkTableViewCell")
        myTableView.reloadData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        ManagerWorkServices.shared.getListWork {[weak self] response in
            print(response)
            self?.listItem = response
            self?.myTableView.reloadData()
        }
    }
    
  
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        ManagerWorkServices.shared.deleteListWork(id: listItem[indexPath.row].id) { [weak self] status in
            if status {
                self?.fetchData()
            } else {
                let alert = UIAlertController(title: "Lỗi", message: "Xoá thất bại", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
   
}



