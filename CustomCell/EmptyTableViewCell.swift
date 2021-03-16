//
//  EmptyTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/5/3.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import SnapKit
class EmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var icon:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "暂无资料  \n 请选择其他选项"
        contentView.backgroundColor = Themes.sectionBackground
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
