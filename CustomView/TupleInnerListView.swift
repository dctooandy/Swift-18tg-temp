//
//  TupleInnerListView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class TupleInnerListView: UIView,Nibloadable
{
    @IBOutlet var leftImageView : UIImageView!
    @IBOutlet var topLeftLabel : UILabel!
    @IBOutlet var topRightLabel : UILabel!
    @IBOutlet var moneyLabel : UILabel!
    @IBOutlet var bottomLeftLabel : UILabel!
    @IBOutlet var bottomRightLabel : UILabel!
    @IBOutlet var bottomLineLabel : UILabel!
    @IBOutlet var tapButton : UIButton!
    var addGamePoolData: HG_AddGamePoolData!
    var weekWinnerData: HG_WeekWinnerData!
    var oddsGameData: HG_OddsGameData!
    var gameFlag : TupleViewFlag!
    var gameBadgeUrl : String = ""
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
