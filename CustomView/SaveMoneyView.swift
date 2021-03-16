//
//  SaveMoneyView.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/18.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import SDWebImageSVGCoder
class SaveMoneyView: UIView ,Nibloadable , UITextFieldDelegate
{
    var hostView : ViewController!
    @IBOutlet var mainStackView : UIStackView!
    @IBOutlet var insertBankCardView : UIView!
    @IBOutlet var gradientLayerView : UIView!
    @IBOutlet var channelContainerView1: UIView!
    @IBOutlet var channelContainerView2: UIView!
    @IBOutlet var channelContainerView3: UIView!
    @IBOutlet var channelContainerView4: UIView!
    @IBOutlet var channelContainerView5: UIView!
    
    @IBOutlet var underView1 : UIView!
    @IBOutlet var underView2 : UIView!
    @IBOutlet var underView3 : UIView!
    @IBOutlet var underView4 : UIView!
    @IBOutlet var underView5 : UIView!
    @IBOutlet var underView6 : UIView!
    
    // 存款成功頁面
    @IBOutlet var bankPruchaseResultView : UIView!
    @IBOutlet var titlebankShortNameLabel : UILabel!
    @IBOutlet var titleBankImageView : UIImageView!
    @IBOutlet var titlebankNameLabel : UnderlinedLabel!
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet var cardNumberLabel : UILabel!
    @IBOutlet var amountLabel : UILabel!
    @IBOutlet var plusStringLabel : UILabel!
    @IBOutlet var unionQRCodeResultContainerView : UIView!
    @IBOutlet weak var topConstraint : NSLayoutConstraint!
    var unionQRCodeResultView : UnionQRCodeResultView!
    // 存款成功資訊
    // 網銀
    private var _netBankSuccessDataAtInnerView : HG_PaymentPayBankDto!
    var netBankSuccessDataAtInnerView : HG_PaymentPayBankDto!
    {
        get{
            return _netBankSuccessDataAtInnerView
        }
        set{
            _netBankSuccessDataAtInnerView = newValue
            self.setupDefaultConstraint()
            if _netBankSuccessDataAtInnerView != nil
            {
                self.setupBankPurchaseResultView()
            }
            
        }
    }
    // 微信
    private var _wechatSuccessDataAtInnerView : HG_PaymentPayThirdpayDto!
    var wechatSuccessDataAtInnerView : HG_PaymentPayThirdpayDto!
    {
        get{
            return _wechatSuccessDataAtInnerView
        }
        set{
            _wechatSuccessDataAtInnerView = newValue
            self.setupDefaultConstraint()
            if _wechatSuccessDataAtInnerView != nil
            {
                self.setupWeChatFuncAction()
            }
        }
    }
    // 銀聯QRCode
    private var _unionQRCodeSuccessDataAtInnerView : HG_PaymentPayThirdpayDto!
    var unionQRCodeSuccessDataAtInnerView : HG_PaymentPayThirdpayDto!
    {
        get{
            return _unionQRCodeSuccessDataAtInnerView
        }
        set{
            _unionQRCodeSuccessDataAtInnerView = newValue
            self.setupDefaultConstraint()
            if _unionQRCodeSuccessDataAtInnerView != nil
            {
                self.setupUnionQRcodeResultContainerView()
            }
            else
            {
//                self.setupUnionQRcodeResultContainerView()
            }
        }
    }
    // 單筆存款說明
    @IBOutlet var descriptionLabel : UILabel!
    var forShowBankNameSelectionArray : [String] = []
    var forShowBankIconSelectionArray : [String] = []
    var forNetTransBankCodeArray : [String] = []
    var forNetTransCurrentBankCodeString : String = ""
    var forNetTransBankSnArray : [String] = []
    var forNetTransCurrentBankSnString : String = ""
    // under View
    @IBOutlet var supportBankStackView : UIStackView!
    @IBOutlet var currentBankLabel : UILabel!
    @IBOutlet var confirmButton : UIButton!
    @IBOutlet var checkMarkButton : UIButton!
    var checkMarkOn : Bool! = true
    var checkAmount : Bool! = false
    // 輸入金額
    @IBOutlet var inputMoneyTextfield : UITextField!
    
    @IBOutlet var bankImageView : UIImageView!
    private var _currentChannelMode : CashChannelMode!
    var currentChannelMode : CashChannelMode!
    {
        get{
            return _currentChannelMode
        }
        set{
            _currentChannelMode = newValue
            changeUnderViewUIAction(_currentChannelMode)
        }
    }
    
    private var _cashierChannelAtInnerView : HG_CashierChannelDto!
    var cashierChannelAtInnerView : HG_CashierChannelDto!
    {
        get{
            return _cashierChannelAtInnerView
        }
        set{
            _cashierChannelAtInnerView = newValue
            setupChannelBorder()
            setupSVGUIAndModelView()
            
        }
    }
    var forShowBankChannel : HG_CashierChannelDataDto!
    
    var memberBankListAtInnerView : [HG_MemberBankList]!
    var userBankListAtInnerView : HG_GetUserBankListDto!
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        let theView = UIView(frame: mainStackView.frame)
        theView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainStackView.addSubview(theView)
        theView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(Views.screenWidth)
            maker.centerX.equalToSuperview()
        }
        mainStackView.sendSubviewToBack(theView)
        setDetectKeyboard()
        setupInputAction()
        checkMarkOn = false
        setupCheckMarkButton()
        checkMarkButton.setImage(nil, for: .normal)
        setupLayerView()
        insertBankCardView.layer.borderColor = UIColor.lightGray.cgColor
        insertBankCardView.layer.borderWidth = 1
        
//        setupUnionQRcodeResultContainerView()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setupLayerView()
    {
        gradientLayerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: 60)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientLayerView.bounds
        gradientLayer.colors = [Themes.leadingBlueLayer.cgColor,Themes.middleBlueLayer.cgColor,Themes.traillingBlueLayer.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0,0.5, 1]
        gradientLayerView.layer.addSublayer(gradientLayer)
    }
    func setupCheckMarkButton()
    {
        checkMarkButton.layer.borderWidth = 1
        checkMarkButton.layer.borderColor = UIColor.black.cgColor
    }
    func setupChannelBorder()
    {
        channelContainerView1.layer.borderColor = Themes.grayLayer.cgColor
        channelContainerView2.layer.borderColor = Themes.grayLayer.cgColor
        channelContainerView3.layer.borderColor = Themes.grayLayer.cgColor
        channelContainerView4.layer.borderColor = Themes.grayLayer.cgColor
        channelContainerView5.layer.borderColor = Themes.grayLayer.cgColor
        
        channelContainerView1.layer.borderWidth = 1
        channelContainerView2.layer.borderWidth = 1
        channelContainerView3.layer.borderWidth = 1
        channelContainerView4.layer.borderWidth = 1
        channelContainerView5.layer.borderWidth = 1
    }
    func setupSVGUIAndModelView()
    {
        for i in 1...5
        {
            if let innerView = self.viewWithTag(i)
            {
                innerView.isHidden = true
                for subview in innerView.subviews
                {
                    subview.removeFromSuperview()
                }
            }
        }
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        let SVGImageSize = CGSize(width: 30, height: 30)
        var alreadySetCashChannel = false
        for i in 0...(cashierChannelAtInnerView.data.count-1)
        {
            let data = cashierChannelAtInnerView.data[i]
            let saveMoneyUpModelView = SaveMoneyUpModelView.loadNib()
            let containerView = self.viewWithTag(i+1)
            var frame = saveMoneyUpModelView.frame
            frame.size = (containerView?.frame.size)!
            saveMoneyUpModelView.frame = frame
            containerView?.addSubview(saveMoneyUpModelView)
            containerView?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
            saveMoneyUpModelView.channelImageView.sd_setImage(with: URL(string: data.ChannelIcon!), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
            })
            saveMoneyUpModelView.channelLabel.text = data.ChannelName
            saveMoneyUpModelView.channelTapButton.tag = i+1
//            if data.ChannelName?.caseInsensitiveCompare("極速通道") == ComparisonResult.orderedSame
//            {
//                saveMoneyUpModelView.channelTapButton.tag = CashChannelMode.FastChannel.rawValue
//            }
//            if data.ChannelName?.caseInsensitiveCompare("銀聯") == ComparisonResult.orderedSame
//            {
//                saveMoneyUpModelView.channelTapButton.tag = CashChannelMode.SilverChannel.rawValue
//            }
//            if data.ChannelName?.caseInsensitiveCompare("支付宝") == ComparisonResult.orderedSame
//            {
//                saveMoneyUpModelView.channelTapButton.tag = CashChannelMode.AlipayChannel.rawValue
//            }
//            if data.ChannelName?.caseInsensitiveCompare("UNIONPAY") == ComparisonResult.orderedSame
//            {
//                saveMoneyUpModelView.channelTapButton.tag = CashChannelMode.UnionChannel.rawValue
//            }
            
            if alreadySetCashChannel == false
            {
                alreadySetCashChannel = true
                saveMoneyUpModelView.channelTapButton.sendActions(for: .touchUpInside)
            }
            
        }
    }
    @IBAction func handleForChangeRadioImage(_ sender : UIButton)
    {
        let onImage = UIImage(named: "RadioOn")
        let offImage = UIImage(named: "RadioOff")
        for i in 1...5
        {
            if let innerView = self.viewWithTag(i)
            {
               
                if let modelView = innerView.viewWithTag(9527) as? SaveMoneyUpModelView
                {
                    if i == sender.tag
                    {
                        if bankPruchaseResultView.isHidden == false
                        {
                            netBankSuccessDataAtInnerView = nil
                            bankPruchaseResultView.isHidden = true
                            hostView.hgServiceNetBankSuccessData = nil
                        }
                        
                        forShowBankChannel = cashierChannelAtInnerView.data[sender.tag-1]
                        modelView.channelRadioImageView.image = onImage
                        currentChannelMode = returnChannelMode(forShowBankChannel.ChannelName!)
                    }else
                    {
                        modelView.channelRadioImageView.image = offImage
                    }
                }
            }
        }
    }
    func changeUnderViewUIAction(_ sender : CashChannelMode)
    {
        switch sender
        {
        case .FastChannel:
            print("極速")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = false
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case .SilverChannel:
            print("銀聯")
            underView1.isHidden = false
            underView2.isHidden = false
            underView3.isHidden = false
            underView4.isHidden = false
            underView5.isHidden = true
            underView6.isHidden = false
        case .AlipayChannel:
            print("支付宝")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = true
            underView4.isHidden = true
            underView5.isHidden = false
            underView6.isHidden = false
        case .UnionChannel:
            print("UNIONPAY")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = true
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case . NetBankChannel:
            print("網銀")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = false
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case . WeChatChannel:
            print("微信")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = true
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case . UnionQRCodeChannel:
            print("銀聯QRCode")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = true
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case . NOCARDChannel:
            print("快捷支付")
            underView1.isHidden = true
            underView2.isHidden = false
            underView3.isHidden = false
            underView4.isHidden = true
            underView5.isHidden = true
            underView6.isHidden = false
        case .None:
            break
        }
        if unionQRCodeResultView != nil
        {
            unionQRCodeResultView.dismissViewAction(nil)
        }
        setupChannelData(sender)
    }
    func setupChannelData(_ sender : CashChannelMode)
    {
        // 選擇銀行View
        forShowBankNameSelectionArray.removeAll()
        forShowBankIconSelectionArray.removeAll()
        forNetTransBankCodeArray.removeAll()
        forNetTransBankSnArray.removeAll()
        
        descriptionLabel.text = forShowBankChannel.SingleMin! + "~" + forShowBankChannel.SingleMax! + (forShowBankChannel.Message ?? "")
        if sender == .NetBankChannel
        {
            if forShowBankChannel.SupportBankCode != nil
            {
                if let dict = forShowBankChannel.SupportBankCode
                {
                    forShowBankNameSelectionArray.removeAll()
                    forShowBankIconSelectionArray.removeAll()
                    forNetTransBankCodeArray.removeAll()
                    
                    for innerDict in dict
                    {
                        forShowBankNameSelectionArray.append(innerDict.value.BankName!)
                        forShowBankIconSelectionArray.append(innerDict.value.BankIcon!)
                        forNetTransBankCodeArray.append(dict.keys.first!)
                    }
                }
                forNetTransCurrentBankCodeString = forNetTransBankCodeArray.count > 0 ? forNetTransBankCodeArray[0] : ""
                currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] : ""
                let SVGCoder = SDImageSVGCoder.shared
                SDImageCodersManager.shared.addCoder(SVGCoder)
                let SVGImageSize = CGSize(width: 30, height: 30)
                    self.bankImageView.sd_setImage(with: URL(string: (self.forShowBankIconSelectionArray.count > 0 ? self.forShowBankIconSelectionArray[0]: "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
            }
        }else if sender == .NOCARDChannel
        {
            if forShowBankChannel.SupportBankCode != nil
            {
                if let dict = forShowBankChannel.SupportBankCode
                {
                    forShowBankNameSelectionArray.removeAll()
                    forShowBankIconSelectionArray.removeAll()
                    forNetTransBankCodeArray.removeAll()
                    
                    for innerDict in dict
                    {
                        forShowBankNameSelectionArray.append(innerDict.value.BankName!)
                        forShowBankIconSelectionArray.append(innerDict.value.BankIcon!)
                        forNetTransBankCodeArray.append(dict.keys.first!)
                    }
                }
                forNetTransCurrentBankCodeString = forNetTransBankCodeArray.count > 0 ? forNetTransBankCodeArray[0] : ""
                currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] : ""
                let SVGCoder = SDImageSVGCoder.shared
                SDImageCodersManager.shared.addCoder(SVGCoder)
                let SVGImageSize = CGSize(width: 30, height: 30)
                self.bankImageView.sd_setImage(with: URL(string: (self.forShowBankIconSelectionArray.count > 0 ? self.forShowBankIconSelectionArray[0]: "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
            }
        }
        else if sender == .FastChannel
        {
            if forShowBankChannel.SupportBankCode != nil
            {
                if let dict = forShowBankChannel.SupportBankCode
                {
                    
                    for innerDict in dict
                    {
                        forShowBankNameSelectionArray.append(innerDict.value.BankName!)
                        forShowBankIconSelectionArray.append(innerDict.value.BankIcon!)
                        forNetTransBankCodeArray.append(dict.keys.first!)
                    }
                }
                forNetTransCurrentBankCodeString = forNetTransBankCodeArray.count > 0 ? forNetTransBankCodeArray[0] : ""
                currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] : ""
                let SVGCoder = SDImageSVGCoder.shared
                SDImageCodersManager.shared.addCoder(SVGCoder)
                let SVGImageSize = CGSize(width: 30, height: 30)
                //MARK: SVG are not thread safe
                var delaytime  = 0.1
                if !UserDefaults.SVGInfo.bool(forKey: .isLoadBefore) {
                    delaytime = 0.8
                    UserDefaults.SVGInfo.set(value: true ,forKey: .isLoadBefore)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delaytime) {
                self.bankImageView.sd_setImage(with: URL(string: (self.forShowBankIconSelectionArray.count > 0 ? self.forShowBankIconSelectionArray[0] : "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
                }
            }
        }else if sender == .SilverChannel
        {
            // 支援銀行 View
            var bankNameArray :[String] = []
            if forShowBankChannel.SupportBankCode != nil
            {
                if let dict = forShowBankChannel.SupportBankCode
                {
                    for innerDict in dict
                    {
                        bankNameArray.append(innerDict.value.BankName!)
                    }
                    for i in 1...bankNameArray.count
                    {
                        if i < 4
                        {
                            let currentLabel = supportBankStackView.viewWithTag(i) as!UILabel
                            currentLabel.isHidden = false
                            currentLabel.text = bankNameArray[i-1]
                        }
                    }
                }
            }
            if let bankInfoArray = forShowBankChannel.Info?.UserBank
            {
                for bankInfo in bankInfoArray
                {
                    let labelString = (bankInfo.BankData?.BankName)! + bankInfo.AccountNo!
                    forShowBankNameSelectionArray.append(labelString)
                    forShowBankIconSelectionArray.append((bankInfo.BankData?.BankIcon)!)
                    forNetTransBankCodeArray.append(bankInfo.AccountBank!)
                    forNetTransBankSnArray.append(bankInfo.Sn!)
                }
            }
            forNetTransCurrentBankSnString = forNetTransBankSnArray.count > 0 ? forNetTransBankSnArray[0] : ""
            forNetTransCurrentBankCodeString = forNetTransBankCodeArray.count > 0 ? forNetTransBankCodeArray[0] : ""
            currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] : ""
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            let SVGImageSize = CGSize(width: 30, height: 30)
            bankImageView.sd_setImage(with: URL(string: (forShowBankIconSelectionArray.count > 0 ? forShowBankIconSelectionArray[0] : "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
        }
    }
    func returnChannelMode(_ sender : String) -> CashChannelMode
    {
        switch sender
        {
        case "極速通道":
            return .FastChannel
        case "銀聯":
            return .SilverChannel
        case "支付宝":
            return .AlipayChannel
        case "UNIONPAY":
            return .UnionChannel
        case "网银":
            return .NetBankChannel
        case "微信":
            return .WeChatChannel
        case "银联QRCode":
            return .UnionQRCodeChannel
        case "快捷支付":
            return .NOCARDChannel
        default:
            return .None
        }
    }
    func returnChannelName(_ sender : CashChannelMode) -> String
    {
        switch sender
        {
        case .FastChannel:
            return "極速通道"
        case .SilverChannel:
            return "銀聯"
        case .AlipayChannel:
            return "支付宝"
        case .UnionChannel:
            return "UNIONPAY"
        case .NetBankChannel:
            return "网银"
        case .WeChatChannel:
            return "微信"
        case .UnionQRCodeChannel:
            return "银联QRCode"
        default :
            return ""
        }
    }
    @IBAction func selectBankAction(_ sender : UIButton)
    {
        setupActionsheet()
    }
    func setupActionsheet()
    {
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertSheet.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        alertSheet.popoverPresentationController?.sourceView = self
        alertSheet.popoverPresentationController?.sourceRect = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 0, height: 0)
        alertSheet.addAction(cancelAction)
        
        if forShowBankNameSelectionArray.count == 0 {
            
            let archiveAction = UIAlertAction(title: "无资料", style: .default, handler: nil)
            alertSheet.addAction(archiveAction)
            hostView.present(alertSheet, animated: true, completion: nil)
            return
        }
        
        for i in 0...forShowBankNameSelectionArray.count-1
        {
            var archiveAction : UIAlertAction!
           
                archiveAction = UIAlertAction(title: forShowBankNameSelectionArray[i], style: UIAlertAction.Style.default, handler:
                    {
                        action in
                        if self.currentChannelMode == .SilverChannel
                        {
                            self.forNetTransCurrentBankSnString = self.forNetTransBankSnArray[i]
                        }
                        
                        self.forNetTransCurrentBankCodeString = self.forNetTransBankCodeArray[i]
                        self.currentBankLabel.text = self.forShowBankNameSelectionArray[i]
                        let SVGCoder = SDImageSVGCoder.shared
                        SDImageCodersManager.shared.addCoder(SVGCoder)
                        let SVGImageSize = CGSize(width: 30, height: 30)
                        DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                        self.bankImageView.sd_setImage(with: URL(string: self.forShowBankIconSelectionArray[i]), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
                        })
                        
                })
            alertSheet.addAction(archiveAction)
        }
        hostView.present(alertSheet, animated: true, completion: nil)
    }
    @IBAction func checkMarkSwitchAction(_ sender : UIButton?)
    {
        checkMarkOn = !checkMarkOn
        let onImage = UIImage(named: "web-checkMark")
        if checkMarkOn == true
        {
            checkMarkButton.setImage(onImage, for: .normal)
        }else
        {
            checkMarkButton.setImage(nil, for: .normal)
        }
    }
    @IBAction func confirmButtonAction(_ sender: UIButton)
    {
        let currentAmount = inputMoneyTextfield.text!
        let productTag = forShowBankChannel.ProductTag!
        let userBankSN = (currentChannelMode == .SilverChannel) ? forNetTransCurrentBankSnString : ""
        if  checkAmount == true
        {
            hostView.addBlurView()
            hostView.addAndStartSpiner()
            hostView.view.isUserInteractionEnabled = false
            switch currentChannelMode
            {
            case CashChannelMode.FastChannel? :
                print("極速 確認")
                hostView.getPaymentPayBank(
                    Amount: currentAmount,
                    BankCode: forNetTransCurrentBankCodeString,
                    ProductTag: productTag,
                    UserBankSn: userBankSN)
            case CashChannelMode.SilverChannel? :
                print("銀聯 確認")
                hostView.getPaymentUnionPayBank(
                    Amount: currentAmount,
                    BankCode: forNetTransCurrentBankCodeString,
                    ProductTag: productTag,
                    UserBankSn: userBankSN)
            case CashChannelMode.AlipayChannel? :
                print("支付寶 確認")
                if checkMarkOn == false
                {
                    hostView.removeBlurView()
                    hostView.removeSpiner()
                    hostView.view.isUserInteractionEnabled = true
                    hostView.showErrorToast(with: "请勾选填写附言信息")
                }else
                {
                    hostView.getPaymentPayThirdpay(
                        Amount: currentAmount,
                        ProductTag: productTag,
                        UserBankSn: userBankSN,
                        BankcodeString: nil)
                }
            case CashChannelMode.UnionChannel? :
                print("UnionPAY 確認")
                hostView.getPaymentPayThirdpay(
                    Amount: currentAmount,
                    ProductTag: productTag,
                    UserBankSn: userBankSN,
                    BankcodeString: nil)
            case CashChannelMode.NetBankChannel? :
                print("網銀 確認")
                hostView.getPaymentPayBank(
                    Amount: currentAmount,
                    BankCode: forNetTransCurrentBankCodeString,
                    ProductTag: productTag,
                    UserBankSn: userBankSN)
            case CashChannelMode.WeChatChannel? :
                print("微信 確認")
                hostView.getPaymentPayThirdpay(
                    Amount: currentAmount,
                    ProductTag: productTag,
                    UserBankSn: userBankSN,
                    BankcodeString: nil)
            case CashChannelMode.UnionQRCodeChannel? :
                print("銀聯QRCode 確認")
                hostView.getPaymentPayThirdpay(
                    Amount: currentAmount,
                    ProductTag: productTag,
                    UserBankSn: userBankSN,
                    BankcodeString: nil)
            case CashChannelMode.NOCARDChannel? :
                print("快捷支付 確認")
                hostView.getPaymentPayThirdpay(
                    Amount: currentAmount,
                    ProductTag: productTag,
                    UserBankSn: userBankSN,
                    BankcodeString: forNetTransCurrentBankCodeString)
            case CashChannelMode.None? :
                print("沒作用")
            default:
                break
            }
        }else
        {
            hostView.showErrorToast(with: "数目小于最低,或高于最高")
        }
    }
    
    // MARK: Detect keyboard height
    func setDetectKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    var selectTextField: UITextField!
    @objc func keyboardDidShow(_ notification: Notification)
    {
        
        if selectTextField == nil { return }
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            if (self.hostView?.customTableviewModeFlag == MainTableviewMode.SaveTransOutMode)
            {
                topConstraint.constant = 20 - keyboardFrame.cgRectValue.height
            }
            selectTextField = nil
        }
    }
    @objc func keyboardDidHide(_ notification: Notification)
    {
            if (self.hostView?.customTableviewModeFlag == MainTableviewMode.SaveTransOutMode)
            {
                topConstraint.constant = 20
            }
            selectTextField = nil
        
    }
    
    // TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == inputMoneyTextfield
        {
            selectTextField = textField
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.endEditing(true)
    }
    func setupInputAction()
    {
        inputMoneyTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield : UITextField)
    {
        let inputString = textfield.text! + ".00"
        let minString = Double(forShowBankChannel.SingleMin!)!
        let maxString = Double(forShowBankChannel.SingleMax!)!
        
        if inputString.count == 0
        {
            print("字數空白")
            checkAmount = false
        }else if let d = Double (inputString), d >= minString ,  d <= maxString
        {
            print("可打錢")
            checkAmount = true
        } else {
            print("數目小於最低,或高於最高")
            checkAmount = false
        }
    }
    func setupBankPurchaseResultView()
    {
        OperationQueue.main.addOperation {
            self.bankPruchaseResultView.isHidden = false
            self.titlebankShortNameLabel.text = self.netBankSuccessDataAtInnerView.data?.bankCode
            self.titlebankNameLabel.text = self.netBankSuccessDataAtInnerView.data?.bankName
            self.titlebankNameLabel.textColor = UIColor.white
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            let SVGImageSize = CGSize(width: 30, height: 30)
            self.titleBankImageView.sd_setImage(with: URL(string: (self.netBankSuccessDataAtInnerView.data?.BankIcon)!), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
            
            self.userNameLabel.text = self.netBankSuccessDataAtInnerView.data?.name
            self.cardNumberLabel.text = self.netBankSuccessDataAtInnerView.data?.bankAccount
            self.amountLabel.text = self.netBankSuccessDataAtInnerView.data?.Amount
            self.plusStringLabel.text = self.netBankSuccessDataAtInnerView.data?.remark
        }
    }
    func setupWeChatFuncAction()
    {
        OperationQueue.main.addOperation {
            if UIApplication.shared.canOpenURL(URL(string: (self.wechatSuccessDataAtInnerView.data?.PayUrl)!)!)
            {
                UIApplication.shared.open((URL(string: (self.wechatSuccessDataAtInnerView.data?.PayUrl)!)!), options: [:], completionHandler: nil)
                self.wechatSuccessDataAtInnerView = nil
                self.hostView.hgServiceWeChatSuccessData = nil
                self.hostView.mainTableView.reloadData()
                self.hostView.scrollToTop()
            }
            else
            {
                self.hostView.showToast(message: Constants.Tiger_ToastError_WebPageUrlError)
            }
        }
    }
    func setupUnionQRcodeResultContainerView()
    {
        unionQRCodeResultContainerView.isHidden = false
        unionQRCodeResultView = UnionQRCodeResultView.loadNib()
        var frame = unionQRCodeResultView.frame
        frame.size = unionQRCodeResultContainerView.frame.size
        unionQRCodeResultView.frame = frame
        unionQRCodeResultContainerView.addSubview(unionQRCodeResultView)
        unionQRCodeResultView.hostView = hostView
        unionQRCodeResultView.unionQRCodeSuccessDataAtResultView = unionQRCodeSuccessDataAtInnerView
    }
    @IBAction func dismissResultViewAction(_ sender : UIButton?)
    {
        netBankSuccessDataAtInnerView = nil
        bankPruchaseResultView.isHidden = true
        hostView.hgServiceNetBankSuccessData = nil
        hostView.mainTableView.reloadData()
        hostView.scrollToTop()
    }
    @IBAction func directToCheckListAction(_ sender:UIButton)
    {
        netBankSuccessDataAtInnerView = nil
        bankPruchaseResultView.isHidden = true
        hostView.hgServiceNetBankSuccessData = nil
        // 加入CheckList Mode
        if hostView.hgServiceCashflowAll != nil
        {
            hostView.mainViewDirectToCashflowRecord()
        }else
        {
            let startDate = hostView.cashflowRecordCalendarDateArray[0]
            let endDate = hostView.cashflowRecordCalendarDateArray[1]
            hostView.currentCashflowRecordFlag = CashflowRecordFlag.All
            hostView.getCashLogAll(startDate: startDate, endDate: endDate, page: "1", more : false)
        }
//        hostView.mainTableView.reloadData()
//        hostView.scrollToTop()
    }
    @IBAction func copyLabelTextAction(_ sender : UIButton)
    {
        switch sender.tag
        {
        case 1:
            print("Copy 名字")
            UIPasteboard.general.string = userNameLabel.text
            hostView.showToast(message: "已複製 姓名")
        case 2:
            print("Copy 卡號")
            UIPasteboard.general.string = cardNumberLabel.text
            hostView.showToast(message: "已複製 卡号")
        case 3:
            print("Copy 金額")
            UIPasteboard.general.string = amountLabel.text
            hostView.showToast(message: "已複製 金额")
        case 4:
            print("Copy 附言")
            UIPasteboard.general.string = plusStringLabel.text
            hostView.showToast(message: "已複製 附言")
        default:
            break
        }
    }
    //添加銀行卡功能
    @IBAction func addBankCardAction(_ sender : UIButton)
    {
        hostView.mainViewDirectToAddBankCard()
    }
    func setupDefaultConstraint()
    {
        self.endEditing(true)
        self.topConstraint.constant = 20
    }
}
