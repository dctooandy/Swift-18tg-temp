//
//  QueryInnerView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/8.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class QueryInnerView: UIView , Nibloadable
{
    var hostView : ViewController!
    var typeArray : [HG_GameGroupGameTagList]!
    var styleArray : [HG_GameGroupGameTagList]!
    var lineCountArray : [HG_GameGroupGameTagList]!
    var promoArray : [HG_GameGroupGameTagList]!
    var querySNArray : [HG_GameGroupGameTagList] = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func animationForQueryContainerView()
    {
        hostView.removeBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let startTransform = CGAffineTransform.init(translationX: 0, y: self.frame.size.height + self.hostView.view.frame.size.height + 100)
                self.hostView.querySelectionContainerView.transform = startTransform
                self.hostView.querySelectionContainerView.isHidden = true
                
        }, completion:nil)
        
    }
    func insertForQueryContainerView()
    {
        setupTagListUI()
        hostView.addBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.querySelectionContainerView.transform = CGAffineTransform.identity
                self.hostView.querySelectionContainerView.isHidden = false
        }, completion:nil)
    }
    func getAllArray()
    {
        typeArray = (hostView.hgServiceGameGroupGameTagList.data as! [HG_GameGroupGameTagList]).filter({ (tagData) -> Bool in
            if tagData.GroupName.caseInsensitiveCompare("类型") == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        })
        styleArray = (hostView.hgServiceGameGroupGameTagList.data as! [HG_GameGroupGameTagList]).filter({ (tagData) -> Bool in
            if tagData.GroupName.caseInsensitiveCompare("风格") == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        })
        lineCountArray = (hostView.hgServiceGameGroupGameTagList.data as! [HG_GameGroupGameTagList]).filter({ (tagData) -> Bool in
            if tagData.GroupName.caseInsensitiveCompare("线数") == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        })
        promoArray = (hostView.hgServiceGameGroupGameTagList.data as! [HG_GameGroupGameTagList]).filter({ (tagData) -> Bool in
            if tagData.GroupName.caseInsensitiveCompare("热门推荐") == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        })
        print("类型 : \(typeArray.count),风格 : \(styleArray.count),线数 : \(lineCountArray.count),热门推荐 : \(promoArray.count)")
    }
    func deletaQuerySNArray()
    {
        querySNArray.removeAll()
    }
    func setupTagListUI()
    {
        getAllArray()
//        deletaQuerySNArray()
      
        for view in self.subviews
        {
            if view.tag == 9527
            {
             // 不刪除,此顆是返回按鈕
            }else
            {
                view.removeFromSuperview()
            }
        }
        let titleLabelH = 40
        let fullWidth = Int(hostView.view.bounds.size.width)
        let sideSpace : Int = 20
        let lineSpace = 20
        let rowSpace = 20
        let countPerRow = 3
        let fontSize : CGFloat = 14
        let buttonWH = Int(((fullWidth - lineSpace * (countPerRow-1)) - (sideSpace * 2))/countPerRow)
        let allArray = [typeArray,styleArray,lineCountArray]
        for j in 0...allArray.count-1
        {
            var titleName = ""
            switch j
            {
            case 0 :
                titleName =  typeArray[0].GroupName
            case 1 :
                titleName =  styleArray[0].GroupName
            case 2 :
                titleName =  lineCountArray[0].GroupName
            default:
                titleName = ""
            }
            var tag1BottomTag : Int = 0
            var diff : Int = 0
            if j != 0
            {
                tag1BottomTag = Int(allArray[j-1]![allArray[j-1]!.count-1].Sn)!
                diff = Int((self.viewWithTag(tag1BottomTag)?.frame.maxY)!)
            }
            
            let titleLabel1 = UILabel(frame: CGRect(x: sideSpace, y: diff + sideSpace, width: titleLabelH*2, height: titleLabelH))
            titleLabel1.text = titleName
            self.addSubview(titleLabel1)
            
            for i in 0...(allArray[j]?.count)!-1
            {
                let rowNumber = Int(i / countPerRow)
                let tag1Button : UIButton = UIButton(frame: CGRect(
                    x: (sideSpace + (i % countPerRow) * Int(buttonWH + lineSpace)),
                    y: (Int(titleLabel1.frame.maxY) + sideSpace + rowNumber * (titleLabelH  + rowSpace)),
                    width: buttonWH,
                    height: titleLabelH))
                tag1Button.titleLabel?.font = tag1Button.titleLabel?.font.withSize(fontSize)
                tag1Button.titleLabel?.adjustsFontSizeToFitWidth = true
                tag1Button.titleLabel?.textAlignment = .center
                tag1Button.setTitle(allArray[j]?[i].TagName, for: .normal)
                tag1Button.setTitleColor(Themes.lineBlueColor, for: .normal)
                tag1Button.setTitleColor(UIColor.white, for: .selected)
                tag1Button.setBackgroundImage(UIImage(color: .white, size: tag1Button.frame.size), for: .normal)
                tag1Button.setBackgroundImage(UIImage(color: Themes.lineBlueColor, size: tag1Button.frame.size), for: .selected)
                tag1Button.layer.cornerRadius = CGFloat(titleLabelH / 2)
                tag1Button.clipsToBounds = true
                tag1Button.layer.borderColor = Themes.lineBlueColor.cgColor
                tag1Button.layer.borderWidth = 2
                tag1Button.tag = Int((allArray[j]?[i].Sn)!)!
                tag1Button.addTarget(self, action: #selector(queryButtonTouchAction(_ :)), for: .touchUpInside)
                self.addSubview(tag1Button)
            }
        }
        var bottomButtonTag : Int = 0
        var diff : Int = 0
        
            bottomButtonTag = Int(lineCountArray[lineCountArray.count-1].Sn)!
            diff = Int((self.viewWithTag(bottomButtonTag)?.frame.maxY)!)
        
        let resetButton : UIButton = UIButton(frame: CGRect(x: sideSpace, y: diff + sideSpace, width: titleLabelH*4, height: titleLabelH))
        resetButton.setTitle("重设", for: .normal)
        resetButton.layer.cornerRadius = 7
        resetButton.clipsToBounds = true
        resetButton.layer.borderColor = Themes.lineBlueColor.cgColor
        resetButton.layer.borderWidth = 2
        resetButton.setTitleColor(Themes.lineBlueColor, for: .normal)
        resetButton.addTarget(self, action: #selector(resetAction(_ :)), for: .touchUpInside)
        self.addSubview(resetButton)
        
        let confirmButton : UIButton = UIButton(frame: CGRect(x: sideSpace + Int(resetButton.frame.maxX) , y: diff + sideSpace, width: titleLabelH*4, height: titleLabelH))
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.layer.cornerRadius = 7
        confirmButton.clipsToBounds = true
        confirmButton.setBackgroundImage(UIImage(color: Themes.lineBlueColor, size: confirmButton.frame.size), for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmAction(_ :)), for: .touchUpInside)
        self.addSubview(confirmButton)
        if querySNArray.count > 0
        {
            resetQueryArrayToButton()
        }
    }
    @objc func queryButtonTouchAction(_ sender: UIButton)
    {
        let currentDataArray : [HG_GameGroupGameTagList] = (hostView.hgServiceGameGroupGameTagList!.data as! [HG_GameGroupGameTagList]).filter { (data) -> Bool in
            if data.Sn.caseInsensitiveCompare(String(sender.tag)) == ComparisonResult.orderedSame
            {
                return true
            }else
            {
                return false
            }
        }
        print("tap SN : \(sender.tag) , Data : \(currentDataArray[0].TagName)")
        sender.isSelected = !sender.isSelected
        if  sender.isSelected == true
        {
            querySNArray.append(currentDataArray[0])
        }else
        {
            for data in querySNArray
            {
                if data.Sn == currentDataArray[0].Sn
                {
                   querySNArray.remove(at: querySNArray.indexOfObject(object: data))
                }
            }
        }
    }
    @objc func resetAction(_ sender : UIButton)
    {
        hostView.hgServiceQuerySNArray = []
        for view in self.subviews
        {
            if view is UIButton
            {
                let button :UIButton = view as! UIButton
                button.isSelected = false
            }
        }
        deletaQuerySNArray()
    }
    @objc func confirmAction(_ sender : UIButton)
    {
        print("querySNArray : \(querySNArray.count)")
        hostView.hgServiceQuerySNArray = querySNArray
        hostView.startQuery = true
        hostView.mainViewDirectToGameGroup(hostView!.hgServiceCurrentGamePoolData as! [HG_GamepoolData] , GameGroupOptions.Platform , hostView.hgServiceGroupType)
        dismissQueryContainerView(sender)
    }
    @IBAction func dismissQueryContainerView(_ sender : UIButton)
    {
        animationForQueryContainerView()
    }
    func resetQueryArrayToButton()
    {
        var snStringArray :[String] = []
        for data in querySNArray
        {
            snStringArray.append(data.Sn)
        }
        
        for innerView in self.subviews
        {
            if let isbutton = innerView as? UIButton
            {
                if snStringArray.contains(String(isbutton.tag))
                {
                    isbutton.isSelected = true
                }
            }
        }
    }
}
