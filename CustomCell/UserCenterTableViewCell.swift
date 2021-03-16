//
//  UserCenterTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/13.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class UserCenterTableViewCell: UITableViewCell
{
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var levelLabel : UILabel!
    @IBOutlet var levelImageView : UIImageView!
    @IBOutlet var payAmount : UILabel!
    @IBOutlet var vipFullAmount : UILabel!
    @IBOutlet var cashLabel : UILabel!
    @IBOutlet var progressBar:UIProgressView!
    
    var hostView : ViewController!
    private var _userCenterUserAdminInfo : HG_AdminMember!
    var userCenterUserAdminInfo : HG_AdminMember!
    {
        get{
            return _userCenterUserAdminInfo
        }
        set{
            _userCenterUserAdminInfo = newValue
            self.userNameLabel.text = _userCenterUserAdminInfo.vipDatas?.UserName
            let vipFullA = _userCenterUserAdminInfo.vipDatas?.VipFullAmount ?? "0"
            var vipfinalString = ""
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.maximumFractionDigits = 2
            currencyFormatter.locale = Locale.current
            let payA = _userCenterUserAdminInfo.vipDatas?.PayAmount ?? "0"
            if vipFullA == "更多VIP优惠即将推出"
            {
                vipfinalString = vipFullA
            }else
            {
                let vipFullString = currencyFormatter.string(from: NSNumber(value: Float((vipFullA))!))!
                let vipRange = vipFullString.index(after: vipFullString.startIndex)..<vipFullString.endIndex
                vipfinalString = String(vipFullString[vipRange])
            }
            
            self.vipFullAmount.text = vipfinalString
            let payString = currencyFormatter.string(from: NSNumber(value: Float((payA))!))!
            let payRange = payString.index(after: payString.startIndex)..<payString.endIndex
            self.payAmount.text = String(payString[payRange])
            calculateBar()
            if let cashStr = hostView.hgServiceUserWalletInfo?.first?.Cash ,
                let lockCashString = hostView.hgServiceUserWalletInfo?.first?.LockCash {
            let totalString : String = String((cashStr as NSString).floatValue + (lockCashString as NSString).floatValue)
            let cashString = currencyFormatter.string(from: NSNumber(value: Float((totalString))!))!
            let cashRange = cashString.index(after: cashString.startIndex)..<cashString.endIndex
                self.cashLabel.text = String(cashString[cashRange])
            } else {
                self.cashLabel.text = "Loading..."
            }
            
            self.levelLabel.text = hostView.getLevelFromString((_userCenterUserAdminInfo.vipDatas?.UserLevel ?? "")!)
            self.levelImageView.sdLoad(with: URL(string: (_userCenterUserAdminInfo.vipDatas?.VipImages ?? "")!))

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    private func setupProgressView(){
        var gradientImage = UIImage.gradientImage(with: progressBar.frame,
                                                  colors: [Themes.gradientStartBlue.cgColor, Themes.gradientEndBlue.cgColor],
                                                  locations: nil)
        if vipFullAmount.text == "更多VIP优惠即将推出"
        {
             gradientImage = UIImage.gradientImage(with: progressBar.frame,
                                                      colors: [#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)],
                                                      locations: nil)
        }
        progressBar.progressImage = gradientImage
        progressBar.trackTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    
    private func calculateBar(){
        setupProgressView()
        if vipFullAmount.text == "更多VIP优惠即将推出"
        {
            
            progressBar.setProgress(1.0, animated: true)
        }else
        {
            if let payText = payAmount.text?.split(separator: ".").first ,
                let vipText = vipFullAmount.text?.split(separator: ".").first {
                let pay = Int(payText.replacingOccurrences(of: ",", with: "")) ?? 0
                let vip = Int(vipText.replacingOccurrences(of: ",", with: "")) ?? 1
                let progress = Float(pay) / Float(vip)
                progressBar.setProgress(progress, animated: true)
            } else
            {
                progressBar.setProgress(0.0, animated: true)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // VIP 會員獨享
    @IBAction func vipAction(_ sender : UIButton)
    {
        hostView.mainViewDirectToVIPPage()
    }
    // 返水 救援金 紅利
    @IBAction func receivePrizeAction(_ sender : UIButton)
    {
        let tag = sender.tag
        switch tag
        {
        case 1 :
            print("user center click return water.")
            hostView.resetReceviceBonusData(mode: .ReturnWater)
        case 2 :
            print("user center click rescue gold.")
             hostView.resetReceviceBonusData(mode: .RescueGold)
        case 3 :
            print("user center click red bonus.")
             hostView.resetReceviceBonusData(mode: .RedBonus)
        default :
            break
        }
        hostView.hgServiceReceivePrizeModeByUserCenter = sender
        hostView.mainViewDirectToReceivePrize()
    }
    // 站內信
    @IBAction func inBoxMailAction(_ sender : UIButton)
    {
//        hostView.mainViewDirectToShowMainView()
        hostView.mainViewDirectToInBoxMail()
    }
    // 推播設定
    @IBAction func notificationSettingAction(_ sender: UIButton)
    {
        hostView.mainViewDirectToNotificationSetting()
    }
    // 登出
    @IBAction func userLogoutAction(_ sender : UIButton)
    {
        hostView.mainViewDirectToShowMainView()
        hostView.mainViewDirectToLogout()
        HGSocketIO.share.disconnectSocketAction()
    }
    // 錢包
    @IBAction func walletAction(_ sender : UIButton)
    {
        hostView.mainViewDirectToWallet()
    }
    // 存轉提
    @IBAction func saveMoneyOrCashOutAction(_ sender : UIButton)
    {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.18tiger.savemoneyorcashoutaction")
        hostView.addBlurView()
        hostView.addAndStartSpiner()
        queue.async(group: group, qos: .default) { [weak self] in
            self?.hostView.getGetUserBankList()
            self?.hostView.getAdminMemberData(WithUserName: (self?.hostView.theAdminTuple?.1)!, WithPassword: (self?.hostView.theAdminTuple!.2)!, WithType: "Detail", WithFinger: (self?.hostView.theAdminTuple!.3)!)
        }
        
        group.notify(queue: .main) { [weak self] in
            
            self?.hostView.reloadAndScrollToTop()
            self?.hostView.removeBlurView()
            self?.hostView.removeSpiner()
            if self?.hostView.isCompleteUserAccount == true
            {
                if sender.tag == 1
                {
                    self?.hostView.currentSaveTransOutFlag = SaveTransOutFlag.SaveMoney
                }else if sender.tag == 3
                {
                    self?.hostView.currentSaveTransOutFlag = SaveTransOutFlag.CashOut
                }
                else
                {
                    
                }
                self?.hostView.hgServiceSaveTransOutModeByUserCenter = sender
                self?.hostView.mainViewDirectToSaveTransOut()
            }else
            {
                self?.hostView.showErrorToast(with: Constants.Tiger_UserAccount_Cell_ErrorUserInfoNoCurrect)
                //            hostView.mainViewDirectToPersonalInfo()
            }
        }
      
    }
    @IBAction func changePasswordAction(_ sender:UIButton)
    {
        hostView.mainViewDirectToChangePassword()
    }
 
    @IBAction func personalInfoAction(_ sender:UIButton)
    {
        hostView.mainViewDirectToPersonalInfo()
    }
    @IBAction func cashflowRecordAction(_ sender: UIButton)
    {
        let startDate = hostView.cashflowRecordCalendarDateArray[0]
        let endDate = hostView.cashflowRecordCalendarDateArray[1]
        hostView.currentCashflowRecordFlag = CashflowRecordFlag.All
        hostView.scrollToTop()
        hostView.getCashLogAll(startDate: startDate, endDate: endDate, page: "1", more : false)
        
        
    }
    @IBAction func userBetRecordAction(_ sender: UIButton){
        hostView.mainViewDirectToUserBetReport()
    }
    
}
