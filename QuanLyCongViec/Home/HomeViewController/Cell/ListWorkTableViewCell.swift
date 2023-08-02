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
    @IBOutlet weak var prioritizeLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remindLable: UILabel!
    
    @IBOutlet weak var checkworkImage: UIImageView!
    @IBOutlet weak var workStatusLabel: UILabel!
  
    
    var checkbox: Bool = false
    var didTapEdit: (() -> Void)?
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        myView.layer.cornerRadius = 15
        editView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func gotoEdit(_ sender: UIButton) {
        didTapEdit?()
    }
    
    
    @IBAction func didTapCheckwork(_ sender: UIButton) {
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: nameWorkLable.text ?? "No title")
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        checkbox = !checkbox
        if checkbox {
            checkworkImage.image = UIImage(named: "dry-clean")
            workStatusLabel.text = "Chưa hoàn thành"
            myView.backgroundColor = UIColor.white
//            nameWorkLable.attributedText = attributeString
        } else {
            checkworkImage.image = UIImage(named: "checkmark")
            workStatusLabel.text = "Đã hoàn thành"
            myView.backgroundColor = UIColor(hex: "AFFFB9")
//            nameWorkLable.attributedText = attributeString
        }
        
    }
    
    func configCell(_ model: WorkItem) {
        nameworkLable.text = "Tên công việc: \(model.name)"
        noteLable.text = "Ghi chú: \(model.note)"
        remindLable.text = "Nhắc nhở: \(model.remind.rawValue)"
        prioritizeLable.text = "Mức độ ưu tiên: \(model.prioritize.rawValue)"

        let date = model.dateTime
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY at hh:mm"
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: "GTC + 7")
        timeLabel.text = "Thời gian: \(formatter.string(from: date! ))"
    }
}
