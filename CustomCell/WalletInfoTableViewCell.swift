//
//  WalletInfoTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/14.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class WalletInfoTableViewCell: UITableViewCell
{
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var levelLabel : UILabel!
    @IBOutlet var totalCashLabel : UILabel!
    @IBOutlet var unLockcashLabel : UILabel!
    @IBOutlet var lockCashLabel : UILabel!
    
    var hostView : ViewController!
    private var _walletUserAdminInfo : HG_AdminMember!
    var walletUserAdminInfo : HG_AdminMember!
    {
        get{
            return _walletUserAdminInfo
        }
        set{
            _walletUserAdminInfo = newValue
            self.setupWalletInfoCellUI()
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupWalletInfoCellUI()
    {
        self.userNameLabel.text = _walletUserAdminInfo.vipDatas?.UserName
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current
        
        let cashStr = (hostView.hgServiceUserWalletInfo.first)!.Cash
        let cashString = currencyFormatter.string(from: NSNumber(value: Float((cashStr))!))!
        let cashRange = cashString.index(after: cashString.startIndex)..<cashString.endIndex
        self.unLockcashLabel.text = String(cashString[cashRange])
        
        let lockCashStr = (hostView.hgServiceUserWalletInfo.first)!.LockCash
        let lockCashString = currencyFormatter.string(from: NSNumber(value: Float((lockCashStr))!))!
        let lockCashRange = lockCashString.index(after: lockCashString.startIndex)..<lockCashString.endIndex
        self.lockCashLabel.text = String(lockCashString[lockCashRange])
        
        let totalStr : String = String((cashStr as NSString).floatValue + (lockCashStr as NSString).floatValue)
        let totalString = currencyFormatter.string(from: NSNumber(value: Float((totalStr))!))!
        let totalRange = totalString.index(after: totalString.startIndex)..<totalString.endIndex
        self.totalCashLabel.text = String(totalString[totalRange])
        
        self.levelLabel.text = hostView.getLevelFromString((_walletUserAdminInfo.vipDatas?.UserLevel)!)
    }
}
