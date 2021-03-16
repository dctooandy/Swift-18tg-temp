//
//  TupleSingleView.swift
//  ProjectT
//
//  Created by AndyChen on 2019/2/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class TupleSingleView: UIView , Nibloadable
{
    var hostView : ViewController!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var listView1 : UIView!
    @IBOutlet var listView2 : UIView!
    @IBOutlet var listView3 : UIView!
    @IBOutlet var listView4 : UIView!
    @IBOutlet var listView5 : UIView!
    
    var innerView1 : TupleInnerListView! = TupleInnerListView.loadNib()
    var innerView2 : TupleInnerListView! = TupleInnerListView.loadNib()
    var innerView3 : TupleInnerListView! = TupleInnerListView.loadNib()
    var innerView4 : TupleInnerListView! = TupleInnerListView.loadNib()
    var innerView5 : TupleInnerListView! = TupleInnerListView.loadNib()
    private let placeHolder1 = TupleInnerPlaceholder.loadNib()
    private let placeHolder2 = TupleInnerPlaceholder.loadNib()
    private let placeHolder3 = TupleInnerPlaceholder.loadNib()
    private let placeHolder4 = TupleInnerPlaceholder.loadNib()
    private let placeHolder5 = TupleInnerPlaceholder.loadNib()
    private lazy var placeHolders = [placeHolder1,placeHolder2,placeHolder3,placeHolder4,placeHolder5]
    private lazy var listViews = [listView1,listView2,listView3,listView4,listView5]
    override func awakeFromNib()
    {
        setUpInnerView()
    }
    func setUpInnerView()
    {
        innerView1.tag = 1
        innerView2.tag = 2
        innerView3.tag = 3
        innerView4.tag = 4
        innerView5.tag = 5
        
        listView1.addSubview(innerView1)
        listView2.addSubview(innerView2)
        listView3.addSubview(innerView3)
        listView4.addSubview(innerView4)
        listView5.addSubview(innerView5)
        
        for (index, listView) in listViews.enumerated() {
            placeHolders[index].isHidden = true
            placeHolders[index].alpha = 0
            listView?.addSubview(placeHolders[index])
            placeHolders[index].snp.makeConstraints { (maker) in
                maker.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    func isShowPlaceholder(_ isShow:Bool){
        placeHolders.forEach{ view in
            view.isHidden = !isShow
            view.alpha = isShow ? 1 : 0
            
        }
    }
    
    func setupSelfViewUnHidden(with tag : Int)
    {
        let selfView = self.viewWithTag(tag) as! TupleInnerListView
        selfView.leftImageView.isHidden = false
        selfView.topLeftLabel.isHidden = false
        selfView.topRightLabel.isHidden = false
        selfView.moneyLabel.isHidden = false
        selfView.bottomLeftLabel.isHidden = false
        selfView.bottomRightLabel.isHidden = false
        selfView.bottomLineLabel.isHidden = false
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func tupleTapAction(_ sender: UIButton)
    {
        print("tuple action")
        
        var currentInnverView : TupleInnerListView!
        switch sender.tag
        {
        case 0:
            currentInnverView = innerView1
        case 1:
            currentInnverView = innerView2
        case 2:
            currentInnverView = innerView3
        case 3:
            currentInnverView = innerView4
        case 4:
            currentInnverView = innerView5
        default:
            break
        }
        
        if (currentInnverView.addGamePoolData != nil) ||
            (currentInnverView.weekWinnerData != nil) ||
            (currentInnverView.oddsGameData != nil)
        {
            var gameImageURLString = ""
            switch currentInnverView.gameFlag
            {
            case .AddGame?:
                hostView.gamePopupView.tupleAddGameData = currentInnverView.addGamePoolData
                gameImageURLString = currentInnverView.addGamePoolData.Images
            case .WeekWinner?:
                hostView.gamePopupView.tupleWeekWinnerData = currentInnverView.weekWinnerData
                gameImageURLString = currentInnverView.weekWinnerData.Images
            case .OddsGame?:
                hostView.gamePopupView.tupleOddsGameData = currentInnverView.oddsGameData
                gameImageURLString = currentInnverView.oddsGameData.Images
            default:
                break
            }
            hostView.gamePopupView.gameBadgeView.sdLoad(with: URL(string: currentInnverView.gameBadgeUrl))
            hostView.gamePopupView.gameImageView.sdLoad(with: URL(string: gameImageURLString))
            hostView.gamePopupView.insertGamePopupContainerView()
            
        }
 
    }
}
