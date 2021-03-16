//
//  UserGameBetReportTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/26.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class UserGameBetReportTableViewCell: UITableViewCell {
    
    @IBOutlet var gameNameLabel:UILabel!
    @IBOutlet var betCountLabel:UILabel!
    @IBOutlet var betAmountLabel:UILabel!
    @IBOutlet var activeBetAmountLabel:UILabel!
    @IBOutlet var balanceAmountLabel:BalanceAmountLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(dto:HG_UserGameBetReportDetailDto){
        gameNameLabel.text = dto.GameName
        betCountLabel.text = dto.BetCount
        betAmountLabel.text = dto.BetAmount
        activeBetAmountLabel.text = dto.ActiveBetAmount
        balanceAmountLabel.setText(dto.BalanceAmount)
    }
    
}
