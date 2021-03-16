//
//  UserGameBetHintTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/26.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class UserGameBetHintTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = Themes.hintCellBackgroundBlue
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDate(date:String){
        dateLabel.text = date
    }
    
    
}
