//
//  CashflowDetailTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/25.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class CashflowDetailTableViewCell: UITableViewCell
{
    @IBOutlet var treatImageView : UIImageView!
    @IBOutlet var treatTitleLabel : UILabel!
    
    @IBOutlet var transIDView : UIView!
    @IBOutlet var transIDLabel : UILabel!
    @IBOutlet var transChannelView : UIView!
    @IBOutlet var transChannelLabel : UILabel!
    @IBOutlet var transTypeView : UIView!
    @IBOutlet var transTypeLabel : UILabel!
    @IBOutlet var createTimeView : UIView!
    @IBOutlet var createTimeLabel : UILabel!
    @IBOutlet var transAmountView : UIView!
    @IBOutlet var transAmountLabel : UILabel!
    @IBOutlet var oldCashView : UIView!
    @IBOutlet var oldCashLabel : UILabel!
    @IBOutlet var newCashView : UIView!
    @IBOutlet var newCashLabel : UILabel!
    
    @IBOutlet var treatRemarksView : UIView!
    @IBOutlet var treatRemarksLabel : UILabel!
    var hostView : ViewController!
    private var _forShowCashflowData : Any!
    var forShowCashflowData : Any!
    {
        get{
            return _forShowCashflowData
        }
        set{
            _forShowCashflowData = newValue
            setupCashflowDetailUI()
        }
    }
    
    var forShowCashflowOtherData : Any!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCashflowDetailUI()
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current
        switch hostView.currentCashflowRecordFlag
        {
        case .All? :
            resetHiddenForRecordFlagAll()
            if let detailData = (forShowCashflowData as? HG_GetCashLogAllDataListDto)
            {
                treatImageView.image = UIImage(named: "pic-mb-history-sucess")
                treatTitleLabel.text = "交易成功"
                transIDLabel.text = detailData.ReferSn
                createTimeLabel.text = detailData.Create_At

                let accountNumberString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.ModifyCash)!)))!
                let cashRange = accountNumberString.index(after: accountNumberString.startIndex)..<accountNumberString.endIndex
                transAmountLabel.text = "¥ " + String(accountNumberString[cashRange])
                let oldCashString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.OldCash)!)))!
                let oldCashRange = oldCashString.index(after: oldCashString.startIndex)..<oldCashString.endIndex
                oldCashLabel.text = "¥ " + String(oldCashString[oldCashRange])
                let newCashString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.NewCash)!)))!
                let newCashRange = newCashString.index(after: newCashString.startIndex)..<newCashString.endIndex
                newCashLabel.text = "¥ " + String(newCashString[newCashRange])
                
                // 例外處理
                if detailData.ModifyType == "1" ||
                    detailData.ModifyType == "6" ||
                    detailData.ModifyType == "101" ||
                    detailData.ModifyType == "103"
                {//存款,提款處理中, 提款失敗回款,提款
                    transTypeView.isHidden = true
                    transChannelLabel.text = detailData.ChannelName
                    
                }
                else if detailData.ModifyType == "102" ||
                    detailData.ModifyType == "2"
                {//轉出
                    transChannelView.isHidden = true
                    let centerWallet = "中心钱包"
                    if let number = Double(detailData.ModifyCash) , number < 0
                    {
                        transTypeLabel.text = "\(centerWallet) -> \(detailData.ChannelName!)"
                    }else
                    {
                        transTypeLabel.text = "\(detailData.ChannelName!) ->\(centerWallet)"
                    }
                    
                }
                else if detailData.ModifyType == "202"
                {
                    transTypeView.isHidden = true
                    transChannelView.isHidden = true
                }
                else
                {
                    
                }
                treatRemarksView.isHidden = true
            }
        case .SaveMoney? :
            resetHiddenForRecordFlagAll()
            if let detailData = (forShowCashflowData as? HG_PaymentQueryOrderDataListDto)
            {
                if detailData.StateCode == "1"
                {//成功
                    treatImageView.image = UIImage(named: "pic-mb-history-sucess")
                    treatTitleLabel.text = "交易成功"
                }
                else if detailData.StateCode == "2"
                {//處理中
                    treatImageView.image = UIImage(named: "pic-mb-history-wait")
                    treatTitleLabel.text = "订单处理中"
                }
                else if detailData.StateCode == "3"
                {//失敗
                    treatImageView.image = UIImage(named: "pic-mb-history-cancel")
                    treatTitleLabel.text = "交易失敗"
                }
                else
                {//新增
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单新增"
                }
                //單類時渠金
                transIDLabel.text = detailData.OrderId
                transTypeLabel.text = "存款交易"
                createTimeLabel.text = detailData.Create_At
                transChannelLabel.text = detailData.ChannelName
                let accountNumberString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.Amount)!)))!
                let cashRange = accountNumberString.index(after: accountNumberString.startIndex)..<accountNumberString.endIndex
                transAmountLabel.text = "¥ " + String(accountNumberString[cashRange])
                oldCashView.isHidden = true
                newCashView.isHidden = true
                treatRemarksView.isHidden = true
            }
        case .CashOut? :
            resetHiddenForRecordFlagAll()
            if let detailData = (forShowCashflowData as? HG_PaymentQueryOrderDataListDto)
            {
                if detailData.StateCode == "1"
                {//成功
                    treatImageView.image = UIImage(named: "pic-mb-history-sucess")
                    treatTitleLabel.text = "交易成功"
                }
                else if detailData.StateCode == "2"
                {//處理中
                    treatImageView.image = UIImage(named: "pic-mb-history-wait")
                    treatTitleLabel.text = "订单处理中"
                }
                else if detailData.StateCode == "3"
                {//失敗
                    treatImageView.image = UIImage(named: "pic-mb-history-cancel")
                    treatTitleLabel.text = "交易失敗"
                    // 應該是 失敗才會有備註
                    treatRemarksView.isHidden = false
                    treatRemarksLabel.text = detailData.Note ?? ""
                }
                else
                {//新增
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单新增"
                }
                //單類時渠金(備)
                transIDLabel.text = detailData.OrderId
                transTypeLabel.text = "存款交易"
                createTimeLabel.text = detailData.Create_At
//                if detailData.ChannelName != nil
//                {
//                    transChannelView.isHidden = false
//                }else
//                {
//                    transChannelView.isHidden = true
//                }
                transChannelLabel.text = detailData.ChannelName
                let accountNumberString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.Amount)!)))!
                let cashRange = accountNumberString.index(after: accountNumberString.startIndex)..<accountNumberString.endIndex
                transAmountLabel.text = "¥ " + String(accountNumberString[cashRange])
                oldCashView.isHidden = true
                newCashView.isHidden = true
            }
        case .TransMoney? :
            resetHiddenForRecordFlagAll()
            if let detailData = (forShowCashflowData as? HG_GetCashLogTransDataListDto)
            {
                if detailData.StateCode == "1"
                {//待派送
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单待派送"
                }
                else if detailData.StateCode == "2"
                {//申請
                    treatImageView.image = UIImage(named: "pic-mb-history-wait")
                    treatTitleLabel.text = "订单处理中"
                }
                else if detailData.StateCode == "3"
                {//成功
                    treatImageView.image = UIImage(named: "pic-mb-history-sucess")
                    treatTitleLabel.text = "交易成功"
                }
                else if detailData.StateCode == "4"
                {//失敗
                    treatImageView.image = UIImage(named: "pic-mb-history-cancel")
                    treatTitleLabel.text = "交易失敗"
                }
                else if detailData.StateCode == "5"
                {//已派送
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单已派送"
                }
                else if detailData.StateCode == "6"
                {//已逾時已逾时
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单已逾时"
                }
                else
                {//新增
                    treatImageView.image = UIImage(named: "pic-mb-bonus")
                    treatTitleLabel.text = "订单新增"
                }
                //單時金(交前)(交後)
                transIDLabel.text = detailData.TrasferOrderId
                createTimeLabel.text = detailData.Create_At
                let accountNumberString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.ModifyCash)!)))!
                let cashRange = accountNumberString.index(after: accountNumberString.startIndex)..<accountNumberString.endIndex
                transAmountLabel.text = "¥ " + String(accountNumberString[cashRange])
                let oldCashString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.OldCash)!)))!
                let oldCashRange = oldCashString.index(after: oldCashString.startIndex)..<oldCashString.endIndex
                oldCashLabel.text = "¥ " + String(oldCashString[oldCashRange])
                let newCashString = currencyFormatter.string(from: NSNumber(value: abs(Float(detailData.NewCash)!)))!
                let newCashRange = newCashString.index(after: newCashString.startIndex)..<newCashString.endIndex
                newCashLabel.text = "¥ " + String(newCashString[newCashRange])
                transChannelView.isHidden = true
                transTypeView.isHidden = true
                treatRemarksView.isHidden = true
            }
        default:
            break
        }
    }
    func resetHiddenForRecordFlagAll()
    {
        transIDView.isHidden = false
        transChannelView.isHidden = false
        transTypeView.isHidden = false
        createTimeView.isHidden = false
        transAmountView.isHidden = false
        oldCashView.isHidden = false
        newCashView.isHidden = false
        treatRemarksView.isHidden = true
    }
    @IBAction func dismissViewAndBackToRecordView(_ sender:UIButton)
    {
        hostView.customTableviewModeFlag = MainTableviewMode.CashflowRecordMode
        hostView.mainViewDirectToCashflowRecord()
    }
    
}
