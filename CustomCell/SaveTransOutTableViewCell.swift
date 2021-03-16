//
//  SaveTransOutTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/18.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class SaveTransOutTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    @IBOutlet var cashOutContainerView : UIView!
    var cashOutView : CashOutView! = CashOutView.loadNib()
    
    @IBOutlet var saveMoneyContainerView : UIView!
    var saveMoneyView : SaveMoneyView! = SaveMoneyView.loadNib()
    
    // 切換頁面用
    private var _currentOptionMode : SaveTransOutFlag!
    var currentOptionMode : SaveTransOutFlag!
    {
        get{
            return _currentOptionMode
        }
        set{
            _currentOptionMode = newValue
            setupCurrentOptionView()
        }
    }
    
    // data source
    // 網銀成功存款
    private var _netBankSuccessData : HG_PaymentPayBankDto!
    var netBankSuccessData : HG_PaymentPayBankDto!
    {
        get{
            return _netBankSuccessData
        }
        set{
            _netBankSuccessData = newValue
            saveMoneyView.netBankSuccessDataAtInnerView = _netBankSuccessData
        }
    }
    // 微信成功存款
    private var _wechatSuccessData : HG_PaymentPayThirdpayDto!
    var wechatSuccessData : HG_PaymentPayThirdpayDto!
    {
        get{
            return _wechatSuccessData
        }
        set{
            _wechatSuccessData = newValue
            saveMoneyView.wechatSuccessDataAtInnerView = _wechatSuccessData
        }
    }
    // 銀聯QRCode成功存款
    private var _unionQRCodeSuccessData : HG_PaymentPayThirdpayDto!
    var unionQRCodeSuccessData : HG_PaymentPayThirdpayDto!
    {
        get{
            return _unionQRCodeSuccessData
        }
        set{
            _unionQRCodeSuccessData = newValue
            saveMoneyView.unionQRCodeSuccessDataAtInnerView = _unionQRCodeSuccessData
        }
    }
    
    private var _userBankList : HG_GetUserBankListDto!
    var userBankList : HG_GetUserBankListDto!
    {
        get{
            return _userBankList
        }
        set{
            _userBankList = newValue
        }
    }
    private var _cashierChannelData : HG_CashierChannelDto!
    var cashierChannelData : HG_CashierChannelDto!
    {
        get{
            return _cashierChannelData
        }
        set{
            _cashierChannelData = newValue
            
        }
    }
    var memberBankList : [HG_MemberBankList]!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setupUI()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI()
    {
        var saveMoneyViewFrame = saveMoneyView.frame
        saveMoneyViewFrame.size = saveMoneyContainerView.frame.size
        saveMoneyView.frame = saveMoneyViewFrame
        saveMoneyContainerView.addSubview(saveMoneyView)
        var cashOutViewFrame = cashOutView.frame
        cashOutViewFrame.size = cashOutContainerView.frame.size
        cashOutView.frame = cashOutViewFrame
        cashOutContainerView.addSubview(cashOutView)
    }
    func setupCurrentOptionView()
    {
        switch currentOptionMode
        {
        case SaveTransOutFlag.SaveMoney? :
            saveMoneyContainerView.isHidden = false
            cashOutContainerView.isHidden = true
            activeSaveMoneyInnerView()
        case SaveTransOutFlag.CashOut? :
            saveMoneyContainerView.isHidden = true
            cashOutContainerView.isHidden = false
            activeCashOutInnerView()
        default:
            break
        }
    }
    func activeSaveMoneyInnerView()
    {
        saveMoneyView.hostView = hostView
        saveMoneyView.memberBankListAtInnerView = memberBankList
        saveMoneyView.cashierChannelAtInnerView = cashierChannelData
        saveMoneyView.userBankListAtInnerView = userBankList
    }
    func activeCashOutInnerView()
    {
        cashOutView.hostView = hostView
        cashOutView.memberBankListAtInnerView = memberBankList
        cashOutView.cashierChannelAtInnerView = cashierChannelData
        cashOutView.userBankListAtInnerView = userBankList
    }
}
