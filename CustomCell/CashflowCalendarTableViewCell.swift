//
//  CashflowCalendarTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/25.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class CashflowCalendarTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    @IBOutlet var dateDiscriptionView : UIView!
    @IBOutlet var dateDiscriptionLabel : UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setTapGestureRecognizer()
    }
    func setTapGestureRecognizer()
    {
        let dateTaps = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        dateDiscriptionView!.addGestureRecognizer(dateTaps)
    }
    @objc func handleTapGesture()
    {
        hostView.calendarInnerView.insertForCashflowRecordCalendarView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
