//
//  BalanceAmountLabel.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/26.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit

class BalanceAmountLabel:UILabel {
    private var money:Double = 0.0
    
    func setText(_ str:String){
        let money = Double(str) ?? 0.00
        textColor = money > 0 ? Themes.trueGreenLayerColor : Themes.falseRedLayerColor
        text = "¥ \(money)"
    }
}
