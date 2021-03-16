//
//  BonusGameWalletTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/6.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class BonusGameWalletTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    var bonusGameWalletData : HG_DefaultModel!
    var moveLineNumber : Int = 3
    var lightOnBottunTag : Int = 0
     var tempMaxY = 0
    var contentSizeHeight: CGFloat = 0
    
    @IBOutlet weak var warringMessageLabel: UILabel!
    @IBOutlet weak var showMoreViewTopContraint: NSLayoutConstraint!
    @IBOutlet var showMoreContainerView : UIView!
    @IBOutlet var showMoreButton : UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var gameBrandLabel: UILabel!
    
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        // Initialization code
        
        let str = "#DCDFE6"
        let index = str.index(str.startIndex, offsetBy: 1)
        let sub_Colorcode = Int(str[index...], radix: 16)
        let borderColor = UIColor(rgb: sub_Colorcode!).cgColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = borderColor
        confirmButton.layer.borderWidth = 1.0
        confirmButton.layer.borderColor = borderColor
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func showMoreAction(_ sender : UIButton)
    {
        animationContainerView()
        showMoreButton.isHidden = true
    }
    func insertContainerView()
    {
        
        self.showMoreContainerView.transform = CGAffineTransform.identity
    }
    func animationContainerView()
    {

        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let sideSpace = 40
                let lineSpace = 20
                 let lineCount = 4
                let defaultH = (Int(self.hostView.view.bounds.size.width) - sideSpace * 2 - (lineCount - 1)  *  lineSpace)  /  lineCount
                let rowSpace = 15
                let companyLabelHeight = 20
                let rowDiff = defaultH + companyLabelHeight + rowSpace
                let topConstraint = Int( self.titleDescriptionLabel.frame.maxY)
                let targetY = self.tempMaxY - (rowDiff * 2 ) - topConstraint
                let translateTransform = CGAffineTransform.init(translationX: 0, y: CGFloat(targetY))
                self.showMoreContainerView.transform = translateTransform
                
        }, completion:nil)
    }
    func resetAllUI()
    {
        resetAllItems()
        insertContainerView()
        setupWalletImage()
        showMoreButton.isHidden = false
        
    }
    
    func resetAllItems() {
        tempMaxY = 0
        lightOnBottunTag = 0
        contentSizeHeight = 0
        
        gameBrandLabel.layer.cornerRadius = 2
        gameBrandLabel.layer.masksToBounds = true
        gameBrandLabel.layer.borderColor = UIColor.lightGray.cgColor
        gameBrandLabel.layer.borderWidth = 1.0
        gameBrandLabel.backgroundColor = UIColor.clear
        
        for view in contentView.subviews {
            if view.isKind(of: UILabel.self)  && view.tag != 1 {
                view.removeFromSuperview()
            } else  if view.isKind(of: UIImageView.self) {
                view.removeFromSuperview()
            } else if view.isKind(of: UIButton.self) {
                view.removeFromSuperview()
            } else if view.isKind(of: UIView.self) {
                for v in view.subviews {
                    if v.tag == 1 {
                        let label = v as! UILabel
                        label.text = "请选择上方游戏品牌"
                    }
                }
            }
        }
    }
    
    func setupWalletImage()
    {
       
       
        if let dataArray = (bonusGameWalletData.data[1] as? Array<Any>)
        {
            let sideSpace = 40
            let lineSpace = 20
            let rowSpace = 15
            let buttonCount = dataArray.count
            let lineCount = 4
            let defaultWH = (Int(hostView.view.bounds.size.width) - sideSpace * 2 - (lineCount - 1)  *  lineSpace)  /  lineCount
            let companyLabelHeight = 20
            let topConstraint = Int(titleDescriptionLabel.frame.maxY) + rowSpace
            let rowDiff = defaultWH + companyLabelHeight + rowSpace
            
            let showMoreViewTop = CGFloat(2*rowDiff + 12)
            let showMoreContainerViewHeight = hostView.mainTableView.frame.height -  showMoreViewTop
            showMoreContainerView.frame.size.height = showMoreContainerViewHeight + 200
            showMoreViewTopContraint.constant = showMoreViewTop
            contentView.setNeedsUpdateConstraints()
            contentView.layoutIfNeeded()
            
            for i in 0...buttonCount-1
            {
                if let groupData = (dataArray[i] as? HG_GameGroupList)
                {
                    
                    let bonusImage : UIImageView = UIImageView(frame: CGRect(x: (sideSpace + (i%lineCount) * (defaultWH + lineSpace)), y: topConstraint + (i/lineCount) * rowDiff , width: defaultWH, height: defaultWH))
                    if let url = URL(string: groupData.Images) {
                        bonusImage.sdLoad(with: url)
                    }
                    bonusImage.layer.cornerRadius = CGFloat(defaultWH/2)
                    bonusImage.clipsToBounds = true
                    let str = groupData.ColorCode
                    if str.hasPrefix("#")
                    {
                        let index = str.index(str.startIndex, offsetBy: 1)
                        let sub_Colorcode = Int(str[index...], radix: 16)
                        bonusImage.backgroundColor = UIColor(rgb: sub_Colorcode!, a: 1)
                    } else {
                        bonusImage.backgroundColor = UIColor.white
                    }
                    
                    let bonusLabel : UILabel = UILabel(frame: CGRect(x:(sideSpace + (i%lineCount) * (defaultWH + lineSpace)), y: Int(bonusImage.frame.maxY), width: Int(defaultWH), height: companyLabelHeight))
                    bonusLabel.text = groupData.CompanyName
                    bonusLabel.textAlignment = .center
                    bonusLabel.font = UIFont.systemFont(ofSize: 15)
                    bonusLabel.lineBreakMode = .byCharWrapping

                    let bonusButton : UIButton = UIButton(frame: CGRect(x: (sideSpace - 1 + (i%lineCount) * (defaultWH + lineSpace)), y: topConstraint - 1 + (i/lineCount) * rowDiff , width: defaultWH + 2, height: defaultWH + companyLabelHeight + 2))
                    bonusButton.tag = (i + 1)
                    bonusButton.layer.borderWidth = 1
                    bonusButton.layer.cornerRadius = CGFloat(7)
                    bonusButton.layer.borderColor = UIColor.clear.cgColor
                    bonusButton.clipsToBounds = true
                    bonusButton.addTarget(self, action: #selector(companyTapAction(_ :)), for: .touchUpInside)
                    
                    self.contentView.addSubview(bonusLabel)
                    self.contentView.addSubview(bonusImage)
                    self.contentView.addSubview(bonusButton)
                    self.contentView.sendSubviewToBack(bonusLabel)
                    self.contentView.sendSubviewToBack(bonusImage)
                    self.contentView.sendSubviewToBack(bonusButton)
                    
                    if  i == buttonCount - 1 { 
                        tempMaxY = Int(bonusButton.frame.maxY)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func confirmTapAction(_ sender: UIButton)
    {
        if lightOnBottunTag == 0 {
            warringMessageLabel.isHidden = false
            return
        }
        warringMessageLabel.isHidden = true
         let dataArray = (bonusGameWalletData.data[1] as! Array<Any>)[lightOnBottunTag - 1] as! HG_GameGroupList

        let userID = hostView.hgServiceReceivePrizeDetailData.UserId
        let sn = hostView.hgServiceReceivePrizeDetailData.Sn
        let groupId = dataArray.GroupId
        let flag = hostView.currentReceivePrizeFlag
        hostView.getGameBonusApply(userID: userID, sn: sn, groupId: groupId, flag: flag!)
       
    }
    
    @IBAction func cancelTapAction(_ sender: UIButton)
    {
        hostView.resetCustomNavigationContainerView()
    }
    
    @objc func companyTapAction(_ sender : UIButton)
    {
        
        if lightOnBottunTag != 0 {
            let lightOnBottun = (self.viewWithTag(lightOnBottunTag) as! UIButton)
            lightOnBottun.layer.borderColor = UIColor.clear.cgColor
        }
        
        let buttonTag = sender.tag
        lightOnBottunTag = buttonTag
        sender.layer.borderColor = UIColor.blue.cgColor
        
        if let dataArray = (bonusGameWalletData.data[1] as? Array<Any>),
            let groupData = (dataArray[buttonTag-1] as? HG_GameGroupList),
            let bonusData = bonusGameWalletData.data[0] as? HG_BonusData
            {
                gameBrandLabel.layer.cornerRadius = 20
                gameBrandLabel.layer.masksToBounds = true
                gameBrandLabel.layer.borderColor = UIColor.blue.cgColor
                gameBrandLabel.layer.borderWidth = 1.0
                gameBrandLabel.backgroundColor = UIColor(red:0.91, green:0.95, blue:1.00, alpha:1.0)
                
                
                let bonusDescrption = """
                \n您选择的是 \(groupData.CompanyName) 游戏
                将转入存款与红利 \(bonusData.Bonus) 元
                \(groupData.CompanyName) 游戏 流水须满  \(bonusData.Limit) 元 才能转帐
                领取红利后请于 3日内达成指定转出要求，否则视同放弃领取，期间产生之赢利与优惠红利将会扣除。\n
                """
                gameBrandLabel.attributedText = setBonusDescrptionTextColor(fullText: bonusDescrption, targetText:  ["您选择的是", "将转入存款与红利", "流水须满", "才能转帐"])
        
        }
    }
    
    
    func setBonusDescrptionTextColor(fullText: String, targetText: [String] ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        for str in targetText {
            attributedString.setColorForText(textForAttribute: str, withColor: .black)
        }
        return attributedString
    }
 
    
}



