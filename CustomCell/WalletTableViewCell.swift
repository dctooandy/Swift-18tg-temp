//
//  WalletTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/14.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    // UI
    @IBOutlet var backgroundContainerView : UIView!
    @IBOutlet var topBannerView : UILabel!
    @IBOutlet var transMoneyButton : UIButton!
    @IBOutlet var saveMoneyButton : UIButton!
    @IBOutlet var cashOutMoneyButton : UIButton!
    @IBOutlet var gameGroupImageView : UIImageView!
    @IBOutlet var groupNameLabel : UILabel!
    @IBOutlet var groupWalletAccountLabel : UILabel!
    // data source
    var currentGroup : HG_GamepoolData!
    private var _gameGroup : HG_Gamepool!
    // touch Action record
    var isTouched : Bool = false
    var gameGroup : HG_Gamepool!
    {
        get{
            return _gameGroup
        }
        set{
            _gameGroup = newValue
            self.setupGameGroupUI()
        }
    }
    private var _gameWallet : Array<String>!
    var gameWallet : Array<String>!
    {
        get{
            return _gameWallet
        }
        set{
            _gameWallet = newValue
            self.setupWalletCellUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContainerView.layer.borderWidth = 1
        backgroundContainerView.layer.borderColor = UIColor.lightGray.cgColor
        transMoneyButton.layer.borderWidth = 1
        transMoneyButton.layer.borderColor = UIColor.lightGray.cgColor
        saveMoneyButton.layer.borderWidth = 1
        saveMoneyButton.layer.borderColor = UIColor.lightGray.cgColor
        cashOutMoneyButton.layer.borderWidth = 1
        cashOutMoneyButton.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupWalletCellUI()
    {
        let currentGameGroup = gameGroup.statusAll.filter { (data) -> Bool in
            if data.GroupName.caseInsensitiveCompare(gameWallet[0]) == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        }
        currentGroup = currentGameGroup[0]
        // Group 圖
        gameGroupImageView.sdLoad(with: URL(string: currentGameGroup[0].Images))
        let str = ((currentGameGroup[0].ColorCode == "null" ) ? "ffffffff" : (currentGameGroup[0].ColorCode == "empty" ) ? "ffffffff" : currentGameGroup[0].ColorCode)
        let index = str.index(str.startIndex, offsetBy: 1)
        let sub_Colorcode = Int(str[index...], radix: 16)
        // Group 背景顏色
        gameGroupImageView.backgroundColor = UIColor(rgb: sub_Colorcode!, a: 1)
        // GroupName
        groupNameLabel.text = gameWallet[2]
        // Group Wallet Account
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current
        
        let cashStr = gameWallet[1]
        let cashString = currencyFormatter.string(from: NSNumber(value: Float((cashStr))!))!
        let cashRange = cashString.index(after: cashString.startIndex)..<cashString.endIndex
        groupWalletAccountLabel.text = String(cashString[cashRange])
        
        
    }
    func setupGameGroupUI()
    {

    }
    @IBAction func moneyFlowAction(_ sender : UIButton)
    {
        switch sender.tag
        {
        case 1:
            print("轉帳")
            hostView.pickedGroupID = currentGroup.GroupId
            isTouched = true
            //        hostView.getGameGroup()
            
            hostView.manualTransView.insertForManualTransView(gameWalletInfo: gameWallet, currentGroup: currentGroup ,image: gameGroupImageView.image!)
//            hostView.getUserWalletInfo(callFor: .AllTableivew)
//            hostView.getGameWalletNew(renewAction: true)
        case 2:
            print("閃入")
//            hostView.currentCellIndexPath = hostView.mainTableView.indexPath(for: self)!
            hostView.pickedGroupID = currentGroup.GroupId
            hostView.addBlurView()
            hostView.addAndStartSpiner()
            hostView.getWalletTransferGame(GroupId: currentGroup.GroupId, UserId: (hostView.userAdminMember.detailDatas?.UserId)! , Type: "1")
        case 3:
            print("閃提")
//            hostView.currentCellIndexPath = hostView.mainTableView.indexPath(for: self)!
            hostView.pickedGroupID = currentGroup.GroupId
            hostView.addBlurView()
            hostView.addAndStartSpiner()
            hostView.getWalletTransferAll(GroupId: currentGroup.GroupId, UserId: (hostView.userAdminMember.detailDatas?.UserId)!)
        default:
            break
        }
    }
}

