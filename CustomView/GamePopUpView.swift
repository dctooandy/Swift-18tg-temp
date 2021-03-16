//
//  GamePopUpView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/11.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import SafariServices
class GamePopUpView: UIView,Nibloadable
{
    var hostView : ViewController!
    private var _gameData : HG_PopularGameData!
    var gameData : HG_PopularGameData!
    {
        get{
            return _gameData
        }
        set{
            _gameData = newValue
            self.setupGamePopupUI()
        }
    }
    private var _tupleAddGameData : HG_AddGamePoolData!
    var tupleAddGameData : HG_AddGamePoolData!
    {
        get{
            return _tupleAddGameData
        }
        set{
            _tupleAddGameData = newValue
            self.gameData = coverAddGameData(_tupleAddGameData)
        }
    }
    private var _tupleWeekWinnerData : HG_WeekWinnerData!
    var tupleWeekWinnerData : HG_WeekWinnerData!
    {
        get{
            return _tupleWeekWinnerData
        }
        set{
            _tupleWeekWinnerData = newValue
            self.gameData = coverWeekWinnerData(_tupleWeekWinnerData)
        }
    }
    private var _tupleOddsGameData : HG_OddsGameData!
    var tupleOddsGameData : HG_OddsGameData!
    {
        get{
            return _tupleOddsGameData
        }
        set{
            _tupleOddsGameData = newValue
            self.gameData = coverOddsGameData(_tupleOddsGameData)
        }
    }
    @IBOutlet var contentStackView:UIStackView!
    @IBOutlet var memberWalletStackView:UIStackView!
    @IBOutlet var walletName :UILabel!
    @IBOutlet var walletNumber : UILabel!
    @IBOutlet var gameImageView : UIImageView!
    @IBOutlet var gameBadgeView : UIImageView!
    @IBOutlet var gameNameLabel : UILabel!
    @IBOutlet var gameLikeCount : UILabel!
    @IBOutlet var playButton : UIButton!
    @IBOutlet var playForFreeButton : UIButton!
    @IBOutlet var addAndCancelButton : UIButton!
    @IBOutlet var dismissButton : UIButton!
    
    private var ptLoginInfo:PTLoginInfo = PTLoginInfo()
    var freePlayUrlForOpen : String! = ""
    var playUrlForOpen : String! = ""
    var ptUrl:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentStackView.spacing = Views.isIPhoneSE() ? 15 : 22
        dismissButton.imageView?.contentMode = .scaleAspectFit
    }
   
    func animationForGamePopupContainerView()
    {
        hostView.removeBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let translateTransform = CGAffineTransform.init(translationX: 0, y: -Views.screenHeight)
                self.hostView.gamePupupContainerView.transform = translateTransform
        }, completion:nil)
    }
    func insertGamePopupContainerView()
    {
        hostView.addBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.gamePupupContainerView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func dismissAction(_ sender : UIButton)
    {
        animationForGamePopupContainerView()
    }
    @IBAction func buttonActionWith(_ sender : UIButton)
    {
        print("Tag \(sender.tag) 點的按鈕")
        switch sender.tag
        {
        case 1:
            print("立即開始玩")
            playNowAction()
        case 2:
            print("免費試玩")
            playForFreeAction()
        case 3:
            print("收藏/取消")
            addCancelLikeAction()
        default:
            break
        }
        
    }
    func playNowAction()
    {
        if checkIfLogin() == true
        {
           presentGameView()
        }else
        {
            animationForGamePopupContainerView()
            hostView.showErrorToast(with: "请先登入")
            hostView.customTableviewModeFlag = MainTableviewMode.LoginActionMode
            hostView.reloadAndScrollToTop()
        }
    }
    func playForFreeAction()
    {
        goAddLike(andPlay: true)
        if gameData.isPT {
            if let url = URL(string: freePlayUrlForOpen) {
            let safariVC = SFSafariViewController(url: url)
            self.hostView.present(safariVC, animated: true, completion: nil)
            } else {
                hostView.showToast(message: "Error URL")
            }
        } else if gameData.isNeedsafari {
            guard let url = URL(string:freePlayUrlForOpen) else {
                hostView.showToast(message: "Decode URL error")
                return
            }
            let safariVC = SFSafariViewController(url:url)
            safariVC.delegate = self
            self.hostView.present(safariVC, animated: true, completion: nil)
        }
        else {
            hostView.gameView.insertForGameWebContainerView()
            hostView.gameView.urlString = freePlayUrlForOpen
        }
    }
    private func presentGameView()
    {
        goAddLike(andPlay: true)
        if gameData.isPT {
            if let url = HGService.share.createEncodeUrl(baseUrl: Constants.Tiger_PTLogin, parameter: ["GameAccount":ptLoginInfo.account,"GamePassword":ptLoginInfo.password,"PlayUrl":ptLoginInfo.url]){
                let safariVC = SFSafariViewController(url: url)
                self.hostView.present(safariVC, animated: true, completion: nil)
            } else {
                hostView.showToast(message: "Decode URL error")
            }
        } else if gameData.isNeedsafari {
            guard let url = URL(string:playUrlForOpen) else {
                hostView.showToast(message: "Decode URL error")
                return
            }
            let safariVC = SFSafariViewController(url:url)
            safariVC.modalPresentationCapturesStatusBarAppearance = true
            safariVC.delegate = self
            self.hostView.present(safariVC, animated: true, completion: nil)
        }
        else {
            hostView.gameView.insertForGameWebContainerView()
            hostView.gameView.urlString = playUrlForOpen
        }
    }
    func addCancelLikeAction()
    {
        if checkIfLogin() == true
        {
            if gameData.Collection == ""
            {
                // 收藏
                goAddLike(andPlay: false)
            }else
            {
                // 取消收藏
                goCancelLike()
            }
        }else
        {
            animationForGamePopupContainerView()
            hostView.customTableviewModeFlag = MainTableviewMode.LoginActionMode
            hostView.mainTableView.reloadData()
            hostView.needHandler = true
            hostView.showErrorToast(with: "请先登入")
        }
    }
    func goCancelLike()
    {
        print("[NetCall]-Add Like Game 資料")
        let successClo : HG_SuccessClosures = { hgService in
            OperationQueue.main.addOperation {
                print("取消收藏完成")
                self.gameData.Collection = ""
                self.gameLikeCount.text = self.gameData.Popular + "♡"
                self.addAndCancelButton.setTitle("收藏游戏", for: .normal)
                if self.hostView.hgServiceGroupOption == GameGroupOptions.Like
                {
                    self.hostView.getGameGroupQueryGameRecordList(.Like)
                }else if self.hostView.hgServiceGroupOption == GameGroupOptions.Played
                {
                    self.hostView.getGameGroupQueryGameRecordList(.Played)
                }
                
                
            }
        }
        let failedClo : HG_FailedClosures = { errorData in
            print("取消收藏失敗")
            
        }
        
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: Constants.Tiger_GameGroup_RecordManage_Delete, withPostString:"Sn=\(gameData.Collection!)&GameId=\(gameData.Sn)&Type=\(gameData.GameType)&UserId=\(hostView.userAdminMember!.detailDatas!.UserId)" , successComplete: successClo, failedException: failedClo)
    }
    func goAddLike(andPlay:Bool)
    {
        print("[NetCall]-Add Like Game 資料")
        let successClo : HG_SuccessClosures = { hgService in
            OperationQueue.main.addOperation {
                print("收藏完成")
                self.gameData.Collection = String((hgService as! [Int])[0])
                self.gameLikeCount.text = String(Int(self.gameData.Popular)! + 1) + "❤"
                self.addAndCancelButton.setTitle("取消收藏", for: .normal)
            }
        }
        let failedClo : HG_FailedClosures = { errorData in
            print("收藏失敗")
        }
        let typeString = (andPlay == false) ? "1" : "2"
        let userIDString = (andPlay == false) ? hostView.userAdminMember!.detailDatas!.UserId: ""
        
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: Constants.Tiger_GameGroup_RecordManage_Add, withPostString:"GameId=\(gameData.Sn)&Type=\(typeString)&UserId=\(userIDString)" , successComplete: successClo, failedException: failedClo)
    }
    func setupGamePopupUI()
    {
        // 上面是否出現錢包金額
        if let userID =  hostView?.userAdminMember?.detailDatas?.UserId
        {
            print("已登入 \(userID)")
            memberWalletStackView.isHidden = false
            walletName.text = gameData.GroupName
            for data in hostView.hgServiceGameWalletNew.data
            {
                if let theData = (data as? Dictionary<String, Dictionary<String, Array<String>>>)
                {
                    if let commonDics = theData["Common"]
                    {
                        if let arrayData = commonDics[gameData.GroupId]
                        {
                            if walletName.text == arrayData[0]
                            {
                                walletNumber.text = arrayData[1]
                                break
                            }
                        }
                    }
                    if let normalDics = theData["Normal"]
                    {
                        if let arrayData = normalDics[gameData.GroupId]
                        {
                            if walletName.text == arrayData[0]
                            {
                                walletNumber.text = arrayData[1]
                                break
                            }
                        }
                    }
                }
            }

        }else
        {
            print("未登入")
            memberWalletStackView.isHidden = true
        }
        // 遊戲名稱
        gameNameLabel.text = gameData.GameName
        //遊戲喜好數目
        var likeBadge = ""
        if gameData.Collection == ""
        {
            likeBadge = "♡"
            addAndCancelButton.setTitle("收藏游戏", for: .normal)
        }else
        {
            likeBadge = "❤"
            addAndCancelButton.setTitle("取消收藏", for: .normal)
        }
        gameLikeCount.text = gameData.Popular + likeBadge
        
        
        // 下面免費遊玩按鈕是否隱藏
        if gameData?.GamePlayTestUrl == ""
        {
            print("沒有測試頁面")
            playForFreeButton.isHidden = true
            
        }else
        {
            print("有測試頁面")
            playForFreeButton.isHidden = false
            goPrefetchFreeGameLoginAction()
        }
        if checkIfLogin() == true
        {
            goPrefetchGameLoginAction()
        }else
        {
            
        }
    }
    func goPrefetchGameLoginAction()
    {
        print("遊戲 URL 拼湊")
        playButton.isEnabled = false
        print("[NetCall]- 遊戲 URL 拼湊 資料")
        let successClo : HG_SuccessClosures = { hgService in
            if let dataDict = hgService as? Dictionary<String , Any>
            {
                if (dataDict["GameAccount"] != nil)
                {
                    print("是PT")
                    if let playurl = dataDict["PlayUrl"] as? String ,
                       let passwordString = dataDict["Password"] as? String,
                       let gameAccountString = dataDict["GameAccount"] as? String {
                       self.ptLoginInfo = PTLoginInfo(account: gameAccountString, password: passwordString, url: playurl)
                        
                    }
//                    if let playurl = dataDict["PlayUrl"] as? String
//                    {   let ptLoginUrl = Constants.Tiger_PTTestLogin
//                        self.playUrlForOpen = Constants.Tiger_PTTestLogin
//                        self.hostView.gameView.ptTempUrl = playurl
//                    }
//                    if let passwordString = dataDict["Password"] as? String
//                    {
//                        self.hostView.gameView.passwordString = passwordString
//                    }
//                    if let gameAccountString = dataDict["GameAccount"] as? String
//                    {
//                        self.hostView.gameView.accountIDString = gameAccountString
//                    }
                }else
                {
                    print("不是PT")
                    if let playurl = dataDict["PlayUrl"] as? String
                    {
                        self.playUrlForOpen = playurl
                    }
                }
                OperationQueue.main.addOperation {
                    self.playButton.isEnabled = true
                }
                
            }else
            {
                print("資料異常")
            }
           
        }
        let failedClo : HG_FailedClosures = { errorData in
            print("error \(errorData ?? "異常")")
            self.hostView.showErrorToast(with: errorData as Any)
        }
        let postString = gameData.GamePlayUrl + "&UserId=" + hostView.userAdminMember.detailDatas!.UserId
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: Constants.Tiger_Game_Login, withPostString:postString , successComplete: successClo, failedException: failedClo)
    }
    func goPrefetchFreeGameLoginAction()
    {
        print("Free 遊戲 URL 拼湊")
        playForFreeButton.isEnabled = false
        print("[NetCall]-Free 遊戲 URL 拼湊 資料")
        let successClo : HG_SuccessClosures = { hgService in
            if let dataDict = hgService as? Dictionary<String , Any>
            {
                    if let playurl = dataDict["PlayUrl"] as? String
                    {
                        self.freePlayUrlForOpen = playurl
                    }
                OperationQueue.main.addOperation {
                    self.playForFreeButton.isEnabled = true
                }
            }else
            {
                print("資料異常")
            }
        }
        let failedClo : HG_FailedClosures = { errorData in
            print("error \(errorData ?? "異常")")
            self.hostView.showErrorToast(with: errorData as Any)
        }
        
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: Constants.Tiger_GamePage_Login, withPostString:gameData.GamePlayTestUrl , successComplete: successClo, failedException: failedClo)
    }
    func checkIfLogin() -> Bool
    {
        if let userIDString = hostView.userAdminMember?.detailDatas?.UserId
        {
            print("已登入 \(userIDString)")
            return true
        }else
        {
            print("未登入 ")
            return false
        }
    }
    func coverAddGameData(_ sender : HG_AddGamePoolData) -> HG_PopularGameData
    {
        let gameList = HG_PopularGameData(
            Collection:"",
            GameCode: sender.GameCode ,
            GameId: sender.GameId ,
            GameMode: sender.GameMode ,
            GameName: sender.GameName ,
            GamePlay: sender.GamePlay ,
            GamePlayTestUrl: sender.GamePlayTestUrl ,
            GamePlayUrl: sender.GamePlayUrl ,
            GameTag: sender.GameTag,
            GameType: sender.GameType ,
            GroupId: sender.GroupId ,
            GroupName: sender.GroupName ,
            GroupStatus: sender.GroupStatus ,
            H5Game: sender.H5Game,
            Images: sender.Images ,
            JackpotBonus: sender.JackpotBonus ,
            JackpotTag: sender.JackpotTag,
            MobileGameCode: sender.MobileGameCode ?? "",
            Play: "",
            Popular: sender.Popular ,
            ReturnType: sender.ReturnType ,
            Sn: sender.Sn ,
            Status: sender.Status ,
            SumBonus: sender.SumBonus ,
            TagGroupName: sender.TagGroupName ,
            TagName: sender.TagName )
        return gameList
    }
    func coverWeekWinnerData(_ sender : HG_WeekWinnerData) -> HG_PopularGameData
    {
        let gameList = HG_PopularGameData(
            Collection:"",
            GameCode: sender.GameCode ,
            GameId: sender.GameId ,
            GameMode: sender.GameMode ,
            GameName: sender.GameName ,
            GamePlay: sender.GamePlay ,
            GamePlayTestUrl: sender.GamePlayTestUrl ,
            GamePlayUrl: sender.GamePlayUrl ,
            GameTag: sender.GameTag,
            GameType: sender.GameType ,
            GroupId: sender.GroupId ,
            GroupName: sender.GroupName ,
            GroupStatus: "" ,
            H5Game: sender.H5Game,
            Images: sender.Images ,
            JackpotBonus: sender.JackpotBonus ,
            JackpotTag: sender.JackpotTag,
            MobileGameCode: sender.MobileGameCode ?? "",
            Play: "",
            Popular: sender.Popular ,
            ReturnType: sender.ReturnType ,
            Sn: sender.Sn ,
            Status: sender.Status ,
            SumBonus: "" ,
            TagGroupName: "" ,
            TagName: "" )
        return gameList
    }
    func coverOddsGameData(_ sender : HG_OddsGameData) -> HG_PopularGameData
    {
        let gameList = HG_PopularGameData(
            Collection:"",
            GameCode: sender.GameCode ,
            GameId: sender.GameId ,
            GameMode: sender.GameMode ,
            GameName: sender.GameName ,
            GamePlay: sender.GamePlay ,
            GamePlayTestUrl: sender.GamePlayTestUrl ,
            GamePlayUrl: sender.GamePlayUrl ,
            GameTag: sender.GameTag,
            GameType: sender.GameType ,
            GroupId: sender.GroupId ,
            GroupName: sender.GroupName ,
            GroupStatus: "" ,
            H5Game: sender.H5Game,
            Images: sender.Images ,
            JackpotBonus: sender.JackpotBonus ,
            JackpotTag: sender.JackpotTag,
            MobileGameCode: sender.MobileGameCode ?? "",
            Play: "",
            Popular: sender.Popular ,
            ReturnType: sender.ReturnType ,
            Sn: sender.Sn ,
            Status: sender.Status ,
            SumBonus: "" ,
            TagGroupName: "" ,
            TagName: "" )
        return gameList
    }
}

fileprivate struct PTLoginInfo {
    let account:String
    let password:String
    let url:String
    init(account:String = "" , password:String = "", url:String = "" ){
        self.account = account
        self.password = password
        self.url = url
    }
}

extension GamePopUpView : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        //MARK: PNG need relogin for each play game
        setupGamePopupUI()
    }
}
