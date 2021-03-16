//
//  CashflowRecordTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/24.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class CashflowRecordTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    private var _currentCashflowRecordFlag : CashflowRecordFlag!
    var currentCashflowRecordFlag : CashflowRecordFlag!
    {
        get{
            return _currentCashflowRecordFlag
        }
        set{
         _currentCashflowRecordFlag = newValue
//            switch _currentCashflowRecordFlag
//            {
//            case .All? :
//                currentData = hostView.hgServiceCashflowAll
//            case .SaveMoney? :
//                currentData = hostView.hgServiceCashflowSaveMoney
//            case .CashOut? :
//                currentData = hostView.hgServiceCashflowCashoutMoney
//            case .TransMoney? :
//                currentData = hostView.hgServiceCashflowTrans
//            default:
//                break
//            }
//            setupLabelUI()
        }
    }
    var currentData : Any!
    var currentOtherData : Any!
    
    @IBOutlet var currentTitleImageView : UIImageView!

    @IBOutlet var currentDateLabel : UILabel!
    @IBOutlet var currentAccountDescriptionLabel : UILabel!
    @IBOutlet var currentFlagLabel : UILabel!
    @IBOutlet var currentAccountNumberLabel : UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupLabelUI()
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current
        var modifyFlagString = ""
        var accountNumberString = ""
        switch currentCashflowRecordFlag
        {
        case .All? :
            if let forShowData = (currentData as? HG_GetCashLogAllDataListDto)
            {
                if forShowData.ModifyType == "1"
                {//存款
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-deposit")
                }
                else if forShowData.ModifyType == "102"
                {//轉出
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-transfer")
                }
                else if forShowData.ModifyType == "101" || forShowData.ModifyType == "103" || forShowData.ModifyType == "6"
                {//提款
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-withdrawal")
                }
                else if forShowData.ModifyType == "5" || forShowData.ModifyType == "105"
                {// 紅利
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-Bonus")
                }
                else if forShowData.ModifyType == "103"
                {// 派發佣金
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-commission")
                }
                else
                {
                    currentTitleImageView.image = #imageLiteral(resourceName: "pic-mb-transfer")
                }
                currentDateLabel.text = forShowData.Create_At
                currentAccountDescriptionLabel.text = forShowData.ChannelName ?? ""
               
                let modifyCashString = currencyFormatter.string(from: NSNumber(value: Float(forShowData.ModifyCash)!))!
                let cashRange = modifyCashString.index(after: modifyCashString.startIndex)..<modifyCashString.endIndex
                
                accountNumberString = currencyFormatter.string(from: NSNumber(value: Float(forShowData.NewCash)!))!
                if let number = Double(forShowData.ModifyCash) , number < 0
                {
                    currentFlagLabel.textColor = Themes.falseRedLayerColor
                    modifyFlagString = "¥ -" + String(modifyCashString[cashRange])
                }else
                {
                    currentFlagLabel.textColor = Themes.trueGreenLayerColor
                    modifyFlagString = "¥ " + String(modifyCashString[cashRange])
                }
            }
        case .SaveMoney? :
            if let forShowData = (currentData as? HG_PaymentQueryOrderDataListDto)
            {
                currentTitleImageView.image = UIImage(named: "pic-mb-deposit")
                currentDateLabel.text = forShowData.Create_At
                currentAccountDescriptionLabel.text = forShowData.ChannelName ?? ""
                if let forShowOtherData = (currentOtherData as? HG_PaymentQueryOrderOtherDto)
                {
                    switch forShowData.StateCode
                    {
                    case "1":
                        currentFlagLabel.textColor = Themes.trueGreenLayerColor
                    case "3":
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    default :
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    }
                    modifyFlagString = forShowOtherData.StateCode[Int(forShowData.StateCode)!]
                }
                accountNumberString = currencyFormatter.string(from: NSNumber(value: Float(forShowData.Amount)!))!
                
            }
        case .CashOut? :
            if let forShowData = (currentData as? HG_PaymentQueryOrderDataListDto)
            {
                currentTitleImageView.image = UIImage(named: "pic-mb-withdrawal")
                currentDateLabel.text = forShowData.Create_At
                currentAccountDescriptionLabel.text = forShowData.ChannelName ?? ""
                if let forShowOtherData = (currentOtherData as? HG_PaymentQueryOrderOtherDto)
                {
                    switch forShowData.StateCode
                    {
                    case "1":
                        currentFlagLabel.textColor = Themes.trueGreenLayerColor
                    case "3":
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    default :
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    }
                    modifyFlagString = forShowOtherData.StateCode[Int(forShowData.StateCode)!]
                }
                accountNumberString = currencyFormatter.string(from: NSNumber(value: Float(forShowData.Amount)!))!
                
            }
        case .TransMoney? :
            if let forShowData = (currentData as? HG_GetCashLogTransDataListDto)
            {
                let centerWallet = "中心钱包"
                currentTitleImageView.image = UIImage(named: "pic-mb-transfer")
                currentDateLabel.text = forShowData.Create_At
                if let number = Double(forShowData.ModifyCash) , number < 0
                {
                    currentAccountDescriptionLabel.text = "\(centerWallet) -> \(forShowData.ChannelName)"
                }else
                {
                    currentAccountDescriptionLabel.text = "\(forShowData.ChannelName) ->\(centerWallet)"
                }
                if let forShowOtherData = (currentOtherData as? HG_GetCashLogTransOtherDto)
                {
                    switch forShowData.StateCode
                    {
                    case "3":
                        currentFlagLabel.textColor = Themes.trueGreenLayerColor
                    case "4":
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    default :
                        currentFlagLabel.textColor = Themes.falseRedLayerColor
                    }
                    modifyFlagString = forShowOtherData.StateCode[forShowData.StateCode]!
                }
                accountNumberString = currencyFormatter.string(from: NSNumber(value: abs(Float(forShowData.ModifyCash)!)))!
            }
        default:
            break
        }
        currentFlagLabel.text = modifyFlagString.replacingOccurrences(of: "$", with: "")
        let cashRange = accountNumberString.index(after: accountNumberString.startIndex)..<accountNumberString.endIndex
        currentAccountNumberLabel.text = "¥ " + String(accountNumberString[cashRange]).replacingOccurrences(of: "$", with: "")
    }
    @IBAction func currentCellDidTapAction(_ sender:UIButton)
    {
        hostView.currentCashflowDetailData = currentData
        hostView.mainViewDirectToCashflowDetail()
    }
}
