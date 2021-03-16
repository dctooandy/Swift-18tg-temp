//
//  InBoxMailTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/26.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class InBoxMailTableViewCell: UITableViewCell
{
    @IBOutlet var titlLabel : UILabel!
    @IBOutlet var contentLabel : UILabel!
    @IBOutlet var deleteMailButton : UIButton!
    @IBOutlet var rightSideButtonContainer : UIView!

    @IBOutlet var touchMask : UIButton!
    
    var inboxMailData : HG_MemberInBoxData!
    var hostView : ViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButtonAction(_ sender: UIButton)
    {
        rightSideButtonContainer.isHidden = false
        inboxMailData.isSideViewHidden = false
    }
    @IBAction func cancelButtonAction(_ sender: UIButton)
    {
        rightSideButtonContainer.isHidden = true
        inboxMailData.isSideViewHidden = true
    }
    @IBAction func confirmButtonAction(_ sender: UIButton)
    {
        rightSideButtonContainer.isHidden = true
        hostView.deleteInboxMailConfirm(inboxMailData)
    }
 
    @IBAction func cellDidSelected(with sender : UIButton)
    {
        hostView.mainViewDirectToLinkWeb(withMethod: .Unique_MailContent, withObject: self.inboxMailData)
    }
   
}
