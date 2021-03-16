//
//  PrizeDetailTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/6.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class PrizeDetailTableViewCell: UITableViewCell
{
    @IBOutlet var modifyCashLabel : UILabel!
    @IBOutlet var offerNameLabel : UILabel!
    @IBOutlet var calcDateLabel : UILabel!
    @IBOutlet var channelNameLabel : UILabel!
    @IBOutlet var calcCashLabel : UILabel!
    @IBOutlet var bonusLimitLabel : UILabel!
    @IBOutlet var withDrawLimitLabel : UILabel!
    @IBOutlet var statusLabel : UILabel!
    @IBOutlet var note2Label : UILabel!
    @IBOutlet var detailConfirmButton : UIButton!
    var hostView : ViewController!
    var otherData : HG_DefaultOther!

    private var _detailData : HG_DefaultReturnPrize!
    var detailData : HG_DefaultReturnPrize!
    {
        get
        {
            return _detailData
        }
        set
        {
            _detailData = newValue
            setupDatailUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func confirmToApply()
    {
        
        hostView.getBonusGameWallet(hostView.currentReceivePrizeFlag, userID: detailData.UserId, sn: detailData.Sn)
    }
    func setupDatailUI()
    {
        
        modifyCashLabel.text = detailData.ModifyCash
        offerNameLabel.text = detailData.OfferName
        calcDateLabel.text = detailData.CalcDate
        channelNameLabel.text = detailData.ChannelName
        calcCashLabel.text = detailData.CalcCash
        bonusLimitLabel.text = detailData.BonusLimit
        withDrawLimitLabel.text = detailData.WithDrawLimit
        statusLabel.text = otherData.Status[detailData.Status]
        note2Label.text = detailData.Notes2
        if detailData.Status == "2"
        {
            detailConfirmButton.isHidden = false
        }else
        {
            detailConfirmButton.isHidden = true
        }
    }
}
