//
//  InnerGroupTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/27.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class InnerGroupTableViewCell: UITableViewCell
{

    @IBOutlet var label1UnderLine : UIView!
    @IBOutlet var label2UnderLine : UIView!
    @IBOutlet var label3UnderLine : UIView!
    @IBOutlet var label4UnderLine : UIView!
    @IBOutlet var label5UnderLine : UIView!

    @IBOutlet var button1 : UIButton!
    @IBOutlet var button2 : UIButton!
    @IBOutlet var button3 : UIButton!
    @IBOutlet var button4 : UIButton!
    @IBOutlet var button5 : UIButton!
    
    @IBOutlet var stackView1 : UIStackView!
    @IBOutlet var stackView2 : UIStackView!
    @IBOutlet var stackView3 : UIStackView!
    @IBOutlet var stackView4 : UIStackView!
    @IBOutlet var stackView5 : UIStackView!
    
    
    
    
    
	var hostView : ViewController!
	var newsList : HG_DefaultModel!
	var promotionsList : HG_DefaultModel!
    private var lastMode:InnerGroupMode?
    var currentGroupMode : MainTableviewMode!
    
	var currentGroup : HG_DefaultModel!
    // News 跟 promotions 用
	var currentList : HG_DefaultModel!
    private lazy var btns = [button1,button2,button3,button4,button5]
    private lazy var underLines = [label1UnderLine,label2UnderLine,label3UnderLine,label4UnderLine,label5UnderLine]
    private lazy var stackViews = [stackView1,stackView2,stackView3,stackView4,stackView5]
//    var isNewsMode : Bool! = false
//    var isPromotionsMode : Bool! = false
//    var isReceivePrizeMode : Bool! = false
//    var isGameGroupOptionMode : Bool! = false
//    var isSaveTransOutMode : Bool! = false
    var currentInnerGroupMode : InnerGroupMode! = .None{
        willSet {
            if lastMode != newValue {
                underLines.forEach{$0?.backgroundColor = .clear}
                label1UnderLine.backgroundColor = Themes.lineBlueColor
            }
        }
        didSet{
            lastMode = currentInnerGroupMode
        }
    }
    // 存轉提
    private var _saveTransOutOption : HG_DefaultModel?
    var saveTransOutOption : HG_DefaultModel?
    {
        get{
            return _saveTransOutOption
        }
        set{
            _saveTransOutOption = newValue
            currentGroup = _saveTransOutOption
            currentGroup.currentTag = 0
            currentInnerGroupMode = .SaveTransOutMode
            self.setupCellTopUI()
        }
    }
    // 資金紀錄
    private var _cashflowRecordOption : HG_DefaultModel?
    var cashflowRecordOption : HG_DefaultModel?
    {
        get{
            return _cashflowRecordOption
        }
        set{
            _cashflowRecordOption = newValue
            currentGroup = _cashflowRecordOption
            currentGroup.currentTag = 0
            currentInnerGroupMode = .CashflowRecordMode
            self.setupCellTopUI()
        }
    }
    
    private var _gameGroupOption : HG_DefaultModel?
    var gameGroupOption : HG_DefaultModel?
    {
        get{
            return _gameGroupOption
        }
        set{
            _gameGroupOption = newValue
            currentGroup = _gameGroupOption
            currentGroup.currentTag = 0
            currentInnerGroupMode = .GameGroupOptionMode
            self.setupCellTopUI()
//            if isGameGroupOptionMode == false
//            {
//                currentGroup.currentTag = 0
//                isNewsMode = false
//                isPromotionsMode = false
//                isReceivePrizeMode = false
//                isGameGroupOptionMode = true
//            }
        }
    }
    private var _receivePrizeGroup : HG_DefaultModel?
    var receivePrizeGroup : HG_DefaultModel!
    {
            get
            {
                return _receivePrizeGroup
            }
            set
            {
                _receivePrizeGroup = newValue
                currentGroup = _receivePrizeGroup
                currentGroup.currentTag = 0
                currentInnerGroupMode = .ReceivePrizeMode
                self.setupCellTopUI()
//                if isReceivePrizeMode == false
//                {
//                    currentGroup.currentTag = 0
//                    isNewsMode = false
//                    isPromotionsMode = false
//                    isReceivePrizeMode = true
//                    isGameGroupOptionMode = false
//                }
            }
    }
    
	private var _promotionsGroup : HG_DefaultModel?
	var PromotionsGroup : HG_DefaultModel!
	{
		get{
			return _promotionsGroup
		}
		set{
			_promotionsGroup = newValue
			currentGroupMode = .PromotionMode
			currentGroup = _promotionsGroup
			currentList = promotionsList
            currentInnerGroupMode = .PromotionsMode
            currentGroup.currentTag = 0
//            if isPromotionsMode == false
//            {
//                currentGroup.currentTag = 0
//                isNewsMode = false
//                isPromotionsMode = true
//                isReceivePrizeMode = false
//                isGameGroupOptionMode = false
//            }
			self.setupCellTopUI()
		}
	}
	
    private var _newsGroup : HG_DefaultModel?
    var newsGroup : HG_DefaultModel!
    {
        get{
            return _newsGroup
        }
        set
        {
            _newsGroup = newValue
			currentGroupMode = .NewsMode
			currentGroup = _newsGroup
			currentList = newsList
            currentInnerGroupMode = .NewsMode
            currentGroup.currentTag = 0
//            if isNewsMode == false
//            {
//                currentGroup.currentTag = 0
//                isNewsMode = true
//                isPromotionsMode = false
//                isReceivePrizeMode = false
//                isGameGroupOptionMode = false
//            }
			self.setupCellTopUI(fillMode: false)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtns()
        // Initialization code
    }
    
    private func setupBtns(){
        btns.forEach{$0?.titleLabel?.adjustsFontSizeToFitWidth = true}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func resetReceivePrizeUnderLine(flag: ReceivePrizeFlag?) {
        switch flag
        {
        case ReceivePrizeFlag.None? :
            currentGroup.currentTag = 1
            label1UnderLine.backgroundColor = Themes.lineBlueColor
            label2UnderLine.backgroundColor = UIColor.clear
            label3UnderLine.backgroundColor = UIColor.clear
            label4UnderLine.backgroundColor = UIColor.clear
            label5UnderLine.backgroundColor = UIColor.clear
            hostView.currentReceivePrizeFlag = ReceivePrizeFlag.ReturnWater
        case ReceivePrizeFlag.ReturnWater? :
            currentGroup.currentTag = 1
            label1UnderLine.backgroundColor = Themes.lineBlueColor
            label2UnderLine.backgroundColor = UIColor.clear
            label3UnderLine.backgroundColor = UIColor.clear
            label4UnderLine.backgroundColor = UIColor.clear
            label5UnderLine.backgroundColor = UIColor.clear
        case ReceivePrizeFlag.RescueGold? :
            currentGroup.currentTag = 2
            label1UnderLine.backgroundColor = UIColor.clear
            label2UnderLine.backgroundColor = Themes.lineBlueColor
            label3UnderLine.backgroundColor = UIColor.clear
            label4UnderLine.backgroundColor = UIColor.clear
            label5UnderLine.backgroundColor = UIColor.clear
        case ReceivePrizeFlag.RedBonus? :
            currentGroup.currentTag = 3
            label1UnderLine.backgroundColor = UIColor.clear
            label2UnderLine.backgroundColor = UIColor.clear
            label3UnderLine.backgroundColor = Themes.lineBlueColor
            label4UnderLine.backgroundColor = UIColor.clear
            label5UnderLine.backgroundColor = UIColor.clear
        default :
            break
        }
    }
    
    func createReceivePrizeGroup()
    {
        let firstPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "1", GroupName: "返水", NewsUserId: "", Status: "", Update_At: "")
        let secondPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "2", GroupName: "救援金", NewsUserId: "", Status: "", Update_At: "")
        let thirdPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "3", GroupName: "红利", NewsUserId: "", Status: "", Update_At: "")
        let receiveGroup : HG_DefaultModel = HG_DefaultModel(status: "1", data: [firstPage,secondPage,thirdPage], message: "", other: "", error_code: "", error_message: "")
        receivePrizeGroup = receiveGroup
    }
    func createGameGroupOption()
    {
        let platformPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "1", GroupName: "平台", NewsUserId: "", Status: "", Update_At: "")
        let hotPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "2", GroupName: "热门", NewsUserId: "", Status: "", Update_At: "")
        let likePage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "3", GroupName: "收藏", NewsUserId: "", Status: "", Update_At: "")
        let playedPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "4", GroupName: "玩过", NewsUserId: "", Status: "", Update_At: "")
//        let seatPage : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "5", GroupName: "包台", NewsUserId: "", Status: "", Update_At: "")
        let gameGroupOptionObject : HG_DefaultModel = HG_DefaultModel(status: "1", data: [platformPage,hotPage,likePage,playedPage], message: "", other: "", error_code: "", error_message: "")
        gameGroupOption = gameGroupOptionObject
    }
    func createSaveTransOutOption()
    {
        let saveMoney : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "1", GroupName: "存款", NewsUserId: "", Status: "", Update_At: "")
        let transCash : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "2", GroupName: "转帐", NewsUserId: "", Status: "", Update_At: "")
        let cashOut : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "3", GroupName: "提款", NewsUserId: "", Status: "", Update_At: "")
        
        let saveTransOutOptionObject : HG_DefaultModel = HG_DefaultModel(status: "1", data: [saveMoney,transCash,cashOut], message: "", other: "", error_code: "", error_message: "")
        saveTransOutOption = saveTransOutOptionObject
    }
    func createCashflowRecordOption()
    {
        let all : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "1", GroupName: "全部", NewsUserId: "", Status: "", Update_At: "")
        let saveMoney : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "2", GroupName: "存款", NewsUserId: "", Status: "", Update_At: "")
        let cashOut : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "3", GroupName: "提款", NewsUserId: "", Status: "", Update_At: "")
        let transCash : HG_NewsAndPromotionsGroupData = HG_NewsAndPromotionsGroupData(GroupId: "4", GroupName: "转帐", NewsUserId: "", Status: "", Update_At: "")
    
        let cashflowRecordOptionObject : HG_DefaultModel = HG_DefaultModel(status: "1", data: [all,saveMoney,cashOut,transCash], message: "", other: "", error_code: "", error_message: "")
        cashflowRecordOption = cashflowRecordOptionObject
    }
    
    
	func resetUI()
	{
        btns.forEach{ $0?.setTitle("", for: .normal)}
        stackView3.isHidden = true
        stackView4.isHidden = true
        stackView5.isHidden = true
        btns.forEach{$0?.isEnabled = true}
	}
    func setupCellTopUI(fillMode:Bool = true)
    {
		resetUI()
        button1.setTitle("全部", for: .normal)
        if currentGroup.currentTag == 0
        {
            switch currentInnerGroupMode
            {
            case InnerGroupMode.CashflowRecordMode? :
                switch hostView.currentCashflowRecordFlag
                {
                case .All? :
                    currentGroup.currentTag = 1
                    label1UnderLine.backgroundColor = Themes.lineBlueColor
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case .SaveMoney? :
                    currentGroup.currentTag = 2
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = Themes.lineBlueColor
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case .CashOut? :
                    currentGroup.currentTag = 3
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = Themes.lineBlueColor
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case .TransMoney? :
                    currentGroup.currentTag = 4
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = Themes.lineBlueColor
                    label5UnderLine.backgroundColor = UIColor.clear
                default :
                    break
                    
                }
            case InnerGroupMode.SaveTransOutMode? :
                switch hostView.currentSaveTransOutFlag
                {
                case SaveTransOutFlag.SaveMoney? :
                    currentGroup.currentTag = 1
                    label1UnderLine.backgroundColor = Themes.lineBlueColor
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case SaveTransOutFlag.TransFlow? :
                    currentGroup.currentTag = 2
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = Themes.lineBlueColor
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case SaveTransOutFlag.CashOut? :
                    currentGroup.currentTag = 3
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = Themes.lineBlueColor
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                default :
                    break
                }
            case InnerGroupMode.ReceivePrizeMode? :
                if let forShowData = hostView?.hgServiceReceivePrizeForShowData,
                    forShowData.data.count > 0
                {
                    hostView.currentReceivePrizeFlag = (hostView.hgServiceReceivePrizeForShowData.data[0] as! HG_DefaultReturnPrize).returnPrizeMode
                }
                resetReceivePrizeUnderLine(flag: hostView.currentReceivePrizeFlag)
//                switch hostView.currentReceivePrizeFlag
//                {
//                case ReceivePrizeFlag.None? :
//                    currentGroup.currentTag = 1
//                    label1UnderLine.backgroundColor = Themes.lineBlueColor
//                    label2UnderLine.backgroundColor = UIColor.clear
//                    label3UnderLine.backgroundColor = UIColor.clear
//                    label4UnderLine.backgroundColor = UIColor.clear
//                    label5UnderLine.backgroundColor = UIColor.clear
//                    hostView.currentReceivePrizeFlag = ReceivePrizeFlag.ReturnWater
//                case ReceivePrizeFlag.ReturnWater? :
//                    currentGroup.currentTag = 1
//                    label1UnderLine.backgroundColor = Themes.lineBlueColor
//                    label2UnderLine.backgroundColor = UIColor.clear
//                    label3UnderLine.backgroundColor = UIColor.clear
//                    label4UnderLine.backgroundColor = UIColor.clear
//                    label5UnderLine.backgroundColor = UIColor.clear
//                case ReceivePrizeFlag.RescueGold? :
//                    currentGroup.currentTag = 2
//                    label1UnderLine.backgroundColor = UIColor.clear
//                    label2UnderLine.backgroundColor = Themes.lineBlueColor
//                    label3UnderLine.backgroundColor = UIColor.clear
//                    label4UnderLine.backgroundColor = UIColor.clear
//                    label5UnderLine.backgroundColor = UIColor.clear
//                case ReceivePrizeFlag.RedBonus? :
//                    currentGroup.currentTag = 3
//                    label1UnderLine.backgroundColor = UIColor.clear
//                    label2UnderLine.backgroundColor = UIColor.clear
//                    label3UnderLine.backgroundColor = Themes.lineBlueColor
//                    label4UnderLine.backgroundColor = UIColor.clear
//                    label5UnderLine.backgroundColor = UIColor.clear
//                default :
//                    break
//                }
            case InnerGroupMode.GameGroupOptionMode? :
                switch hostView.hgServiceGroupOption
                {
                case GameGroupOptions.Platform? :
                    currentGroup.currentTag = 1
                    label1UnderLine.backgroundColor = Themes.lineBlueColor
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case GameGroupOptions.Hot? :
                    currentGroup.currentTag = 2
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = Themes.lineBlueColor
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case GameGroupOptions.Like? :
                    currentGroup.currentTag = 3
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = Themes.lineBlueColor
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = UIColor.clear
                case GameGroupOptions.Played? :
                    currentGroup.currentTag = 4
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = Themes.lineBlueColor
                    label5UnderLine.backgroundColor = UIColor.clear
                case GameGroupOptions.SeatVip? :
                    currentGroup.currentTag = 5
                    label1UnderLine.backgroundColor = UIColor.clear
                    label2UnderLine.backgroundColor = UIColor.clear
                    label3UnderLine.backgroundColor = UIColor.clear
                    label4UnderLine.backgroundColor = UIColor.clear
                    label5UnderLine.backgroundColor = Themes.lineBlueColor
                default :
                    break
                }
            default :
                break
            }
            
        }
        var x = -1
        if (currentInnerGroupMode == .ReceivePrizeMode) ||
            (currentInnerGroupMode == .GameGroupOptionMode) ||
            (currentInnerGroupMode == .SaveTransOutMode) ||
            (currentInnerGroupMode == .CashflowRecordMode)
        {
            x = 0
        }
//        let x = (isReceivePrizeMode == true) ? 0 : ((isGameGroupOptionMode == true) ? 0: -1)
        // setup inner's label titile
        for dataInt in 0...(currentGroup.data.count - 1)
        {
            if let newsGroupData = currentGroup.data[dataInt] as? HG_NewsAndPromotionsGroupData
            {
                if dataInt == x
                {
                    button1.setTitle(newsGroupData.GroupName, for: .normal)
                }
                if dataInt == (x + 1)
                {
                    button2.setTitle(newsGroupData.GroupName, for: .normal)
                }
                if dataInt == (x + 2)
                {
                    button3.setTitle(newsGroupData.GroupName, for: .normal)
                    stackView3.isHidden = false
                }
                if dataInt == (x + 3)
                {
                    button4.setTitle(newsGroupData.GroupName, for: .normal)
                    stackView4.isHidden = false
                }
                if dataInt == (x + 4)
                {
                    button5.setTitle(newsGroupData.GroupName, for: .normal)
                    stackView5.isHidden = false
                }
            }
        }
        if (!fillMode) {
            Array((currentGroup.data.count + 1)...btns.count - 1).forEach{index in
                btns[index]?.isEnabled = false
                stackViews[index]?.isHidden = false
            }
        }
        
        
        // 個人中心點至領獎頁面 例外處理
        if hostView.hgServiceReceivePrizeModeByUserCenter != nil
        {
            innerGroupTapAction(hostView.hgServiceReceivePrizeModeByUserCenter)
            hostView.hgServiceReceivePrizeModeByUserCenter = nil
        }
        // 個人中心點至存轉提頁面 例外處理
        if hostView.hgServiceSaveTransOutModeByUserCenter != nil
        {
            innerGroupTapAction(hostView.hgServiceSaveTransOutModeByUserCenter)
            hostView.hgServiceSaveTransOutModeByUserCenter = nil
        }
    }
    
	func innerGroupTapDataLogic(_ sender : UIButton)
	{
        switch currentInnerGroupMode
        {
        case InnerGroupMode.CashflowRecordMode? :
            let startDate = hostView.cashflowRecordCalendarDateArray[0]
            let endDate = hostView.cashflowRecordCalendarDateArray[1]
            switch sender.tag
            {
                case 1 :
                print("全部被點到")
                hostView.currentCashflowRecordFlag = CashflowRecordFlag.All
                hostView.getCashLogAll(startDate: startDate, endDate: endDate, page: "1", more : false)
                case 2 :
                print("存錢被點到")
                hostView.currentCashflowRecordFlag = CashflowRecordFlag.SaveMoney
                hostView.getQueryOrderForSaveCashOutMoney(PayType: "1", startDate: startDate, endDate: endDate, page: "1", more : false)
                case 3 :
                print("提款被點到")
                hostView.currentCashflowRecordFlag = CashflowRecordFlag.CashOut
                hostView.getQueryOrderForSaveCashOutMoney(PayType: "2", startDate: startDate, endDate: endDate, page: "1", more : false)
                case 4 :
                print("轉帳被點到")
                hostView.currentCashflowRecordFlag = CashflowRecordFlag.TransMoney
                hostView.getCashLogTrans(startDate: startDate, endDate: endDate, page: "1", more : false)
            default :
                break
            }
        case InnerGroupMode.SaveTransOutMode? :
            switch sender.tag
            {
            case 1 :
                print("存錢被點到")
                hostView.currentSaveTransOutFlag = SaveTransOutFlag.SaveMoney
                hostView.mainTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            case 2 :
                print("轉帳被點到")
                hostView.mainViewDirectToWallet()
            case 3 :
                print("提款被點到")
                hostView.currentSaveTransOutFlag = SaveTransOutFlag.CashOut
                hostView.mainTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            default :
                break
            }
            
        case InnerGroupMode.ReceivePrizeMode? :
            switch sender.tag
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
            
            hostView.mainViewDirectToReceivePrize()
        case InnerGroupMode.GameGroupOptionMode? :
            var groupOption : GameGroupOptions = .Platform
            switch sender.tag
            {
            case 1 :
                groupOption = GameGroupOptions.Platform
            case 2 :
                groupOption = GameGroupOptions.Hot
            case 3 :
                groupOption = GameGroupOptions.Like
            case 4 :
                groupOption = GameGroupOptions.Played
            case 5 :
                groupOption = GameGroupOptions.SeatVip
            default :
                break
            }
            hostView.mainViewDirectToGameGroup(hostView!.hgServiceCurrentGamePoolData as! [HG_GamepoolData], groupOption , hostView.hgServiceGroupType )
        default:
            if sender.tag == 1
            {// 全部的Button被點選
                currentList.forShowData = currentList.data
                if currentGroupMode == MainTableviewMode.NewsMode
                {
                    hostView.mainViewDirectToShowNews()
                }
                else if currentGroupMode == MainTableviewMode.PromotionMode
                {
                    hostView.mainViewDirectToShowPromotions()
                }
            }else
            {
                let groupID = String(sender.tag - 1)
                if currentGroupMode == MainTableviewMode.NewsMode
                {
                    let newDatas = currentList.data.filter({(listData) -> Bool in
                        if let listData = listData as? HG_NewsListData {
                            return listData.GroupIds.contains(groupID)
                        }
                        return false
                    })
                    hostView.hgServiceNewsList.forShowData = newDatas
                    hostView.mainViewDirectToShowNews()
                    
                }else if currentGroupMode == MainTableviewMode.PromotionMode
                {
                    let promotionsDatas = currentList.data.filter({(listData) -> Bool in
                        if let listData = listData as? HG_PromotionsListData {
                            return listData.GroupIds.contains(groupID)
                        }
                        return false
                    })
                    hostView.hgServicePromotionsList.forShowData = promotionsDatas
                    hostView.mainViewDirectToShowPromotions()
                }
            }
            
        }

	}
    
    func resetToFirstOption(){
        underLines.forEach{$0?.backgroundColor = .clear}
        label1UnderLine.backgroundColor = Themes.lineBlueColor
    }
    
    @IBAction func innerGroupTapAction(_ sender : UIButton)
    {
        if sender.tag > currentGroup.data.count + 1
        {
           
        }else
        {
            switch sender.tag
            {
            case 1:
                currentGroup.currentTag = 1
                label1UnderLine.backgroundColor = Themes.lineBlueColor
                label2UnderLine.backgroundColor = UIColor.clear
                label3UnderLine.backgroundColor = UIColor.clear
                label4UnderLine.backgroundColor = UIColor.clear
                label5UnderLine.backgroundColor = UIColor.clear
            case 2:
                currentGroup.currentTag = 2
                label1UnderLine.backgroundColor = UIColor.clear
                label2UnderLine.backgroundColor = Themes.lineBlueColor
                label3UnderLine.backgroundColor = UIColor.clear
                label4UnderLine.backgroundColor = UIColor.clear
                label5UnderLine.backgroundColor = UIColor.clear
            case 3:
                currentGroup.currentTag = 3
                label1UnderLine.backgroundColor = UIColor.clear
                label2UnderLine.backgroundColor = UIColor.clear
                label3UnderLine.backgroundColor = Themes.lineBlueColor
                label4UnderLine.backgroundColor = UIColor.clear
                label5UnderLine.backgroundColor = UIColor.clear
            case 4:
                currentGroup.currentTag = 4
                label1UnderLine.backgroundColor = UIColor.clear
                label2UnderLine.backgroundColor = UIColor.clear
                label3UnderLine.backgroundColor = UIColor.clear
                label4UnderLine.backgroundColor = Themes.lineBlueColor
                label5UnderLine.backgroundColor = UIColor.clear
            case 5:
                currentGroup.currentTag = 5
                label1UnderLine.backgroundColor = UIColor.clear
                label2UnderLine.backgroundColor = UIColor.clear
                label3UnderLine.backgroundColor = UIColor.clear
                label4UnderLine.backgroundColor = UIColor.clear
                label5UnderLine.backgroundColor = Themes.lineBlueColor
            default:
                break
            }
			innerGroupTapDataLogic(sender)
        }
    }
}
