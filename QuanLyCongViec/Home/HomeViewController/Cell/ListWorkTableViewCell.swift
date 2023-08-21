//
//  ListWorkTableViewCell.swift
//  QuanLyCongViec
//
//  Created by Quang Viện on 20/07/2023.
//

import UIKit

class ListWorkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var nameworkLable: UILabel!
    @IBOutlet weak var noteLable: UILabel!
    
    @IBOutlet weak var colorPriorityView: UIView!
    @IBOutlet weak var priorityLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remindLable: UILabel!
    
    @IBOutlet weak var checkworkImage: UIImageView!
    @IBOutlet weak var workStatusLabel: UILabel!
    
    var checkbox: Bool = false {
        didSet {
            if !checkbox {
                checkworkImage.image = UIImage(named: "dry-clean")
                workStatusLabel.text = "Chưa hoàn thành"
                myView.backgroundColor = UIColor.white
            } else {
                checkworkImage.image = UIImage(named: "checkmark")
                workStatusLabel.text = "Đã hoàn thành"
                myView.backgroundColor = UIColor(hex: "AFFFB9")
            }
        }
    }
    
    var didTapEdit: (() -> Void)?
    var didTapCheckwork: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 15
        editView.layer.cornerRadius = 10
        colorPriorityView.layer.cornerRadius = self.colorPriorityView.frame.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func gotoEdit(_ sender: UIButton) {
        didTapEdit?()
    }
    
    
    @IBAction func didTapCheckwork(_ sender: UIButton) {
        didTapCheckwork?()
    }
    
    func configCell(_ model: WorkItem) {
        nameworkLable.text = (model.name)
        noteLable.text = "Ghi chú: \(model.note)"
        remindLable.text = "Nhắc nhở: \(model.remind.rawValue)"
        
        switch model.priority {
        case .low:
            priorityLable.text = "Mức độ ưu tiên: Thấp"
            self.colorPriorityView.backgroundColor = UIColor(hex: "0500FF")
            
        case .medium:
            priorityLable.text = "Mức độ ưu tiên: Trung bình"
            self.colorPriorityView.backgroundColor = UIColor(hex: "FFF500")
        case .hight:
            priorityLable.text = "Mức độ ưu tiên: Cao"
            self.colorPriorityView.backgroundColor = UIColor(hex: "FF0000")
        case .none:
            priorityLable.text = "Mức độ ưu tiên: Không có"
            self.colorPriorityView.backgroundColor = UIColor(hex: "E3EFFF")
        }
        
        let date = model.dateTime
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        timeLabel.text = "Thời gian: \(formatter.string(from: date! ))"
    }
}
