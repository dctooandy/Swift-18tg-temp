//
//  VipTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/4.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class VipTableViewCell: UITableViewCell
{
    @IBOutlet var vipWebview : UIWebView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
