//
//  UserBetRecordTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/25.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class UserBetRecordTableViewCell: UITableViewCell {
    
    @IBOutlet var groupNameLabel:UILabel!
    @IBOutlet var betCountLabel:UILabel!
    @IBOutlet var betAmountLabel:UILabel!
    @IBOutlet var activeBetAmountLabel:UILabel!
    @IBOutlet var balanceAmountLabel:UILabel!
    private let disposeBag = DisposeBag()
    private var gameGroupId:String = "0"
    weak var hostView:ViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        bindTap()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func bindTap(){
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe{[weak self] _ in
            guard let weakSelf = self else { return }
           weakSelf.hostView?.mainViewDirectToUserGameBetReport(gameGroupId: weakSelf.gameGroupId)
        }
    }
    
    func configCell(userBetDto:HG_UserBetReportDto){
        gameGroupId = userBetDto.GroupId
        groupNameLabel.text = userBetDto.GroupName
        betCountLabel.text = userBetDto.BetAmount
        betAmountLabel.text = "¥ \(userBetDto.BetAmount)"
        activeBetAmountLabel.text = "¥ \(userBetDto.ActiveBetAmount)"
        let balanceMoney = Double(userBetDto.BalanceAmount) ?? 0.00
        balanceAmountLabel.text = "¥ \(userBetDto.BalanceAmount)"
        balanceAmountLabel.textColor = balanceMoney > 0 ? Themes.trueGreenLayerColor : Themes.falseRedLayerColor
    }
    
}
