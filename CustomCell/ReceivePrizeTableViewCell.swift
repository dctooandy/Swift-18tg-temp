//
//  ReceivePrizeTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/4.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class ReceivePrizeTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    
    @IBOutlet var rotationLabel : UILabel!
    @IBOutlet var cardView : UIView!
    @IBOutlet var limitValueLabel : UILabel!
    @IBOutlet var valueDateLabel : UILabel!
    
    @IBOutlet var channelNameStackView : UIStackView!
    @IBOutlet var channelNameLabel : UILabel!
    @IBOutlet var bonusLimitLabel : UILabel!
    @IBOutlet var modifyCashLabel : UILabel!
    @IBOutlet var offerNameLabel : UILabel!
    private var _otherData : HG_DefaultOther!
    var otherData : HG_DefaultOther!
    {
        get{
            return _otherData
        }
        set{
            _otherData = newValue
            setupRotationLabel()
        }
    }
    private var _forShowData : HG_DefaultReturnPrize!
    var forShowData : HG_DefaultReturnPrize!
    {
        get{
            return _forShowData
        }
        set{
            _forShowData = newValue
            setupData()
            print("\(String(describing: _forShowData))")
        }
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        setupCardUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCardUI()
    {
        cardView.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0).cgColor
        cardView.layer.borderWidth = 1
    }
    func setupRotationLabel()
    {
        rotationLabel.transform = CGAffineTransform(rotationAngle: -(.pi / 4))
        rotationLabel.text = otherData.Status[forShowData.Status]
        switch forShowData.Status
        {
        case "5":
            rotationLabel.backgroundColor = UIColor(red: 103/255, green: 204/255, blue: 102/255, alpha: 1.0)
        case "2":
            rotationLabel.backgroundColor = UIColor(red: 250/255, green: 173/255, blue: 20/255, alpha: 1.0)
        default:
            rotationLabel.backgroundColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1.0)
        }
    }
    
    func setupData()
    {
        limitValueLabel.text = forShowData.WithDrawLimit
        valueDateLabel.text = forShowData.CalcDate
        modifyCashLabel.text = forShowData.ModifyCash
        if forShowData.returnPrizeMode == .ReturnWater
        {
            channelNameStackView.isHidden = false
            offerNameLabel.isHidden = true
            channelNameLabel.text = forShowData.ChannelName
            bonusLimitLabel.text = forShowData.BonusLimit
        }else
        {
            channelNameStackView.isHidden = true
            offerNameLabel.isHidden = false
            offerNameLabel.text = forShowData.OfferName
        }
    }
    @IBAction func cellDidSelected(_ sender : UIButton)
    {
        hostView.hgServiceReceivePrizeOtherData = otherData
        hostView.hgServiceReceivePrizeDetailData = forShowData
        hostView.mainViewDirectToReceivePrizeDetail()
    }
}
