//
//  PromotiomTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/27.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class PromotiomTableViewCell: UITableViewCell
{
	@IBOutlet var backgroundWhiteView : UIView!
	@IBOutlet var contentImage : UIImageView!
	@IBOutlet var promotionsNameLabel :UILabel!
	@IBOutlet var contentLabel : UILabel!
	
	var hostView : ViewController!
	private var _promotionsListData : HG_PromotionsListData?
	var promotionsListData : HG_PromotionsListData!
	{
		get {
			return _promotionsListData
		}
		set {
			_promotionsListData = newValue
			let urlString = _promotionsListData?.Images
            self.contentImage.sdLoad(with: URL(string: urlString!))
			self.promotionsNameLabel.text = _promotionsListData?.PromotionsName
			let removeString = _promotionsListData?.Content.pregReplace(pattern: "<[^>]*>", with: "")
			self.contentLabel.text = removeString
		}
	}
	
	@IBAction func cellDidSelected(with sender : UIButton)
	{
        switch promotionsListData.LinkMethod
        {
        case "1":
           print("第一種")
           hostView.mainViewDirectToLinkWeb(withMethod: .Link1_Popup, withObject: self.promotionsListData)
        case "2":
            print("第二種")
            if let urlString = promotionsListData?.LinkContent,
               let url = URL(string: urlString)  ,
                UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                hostView.showToast(message: Constants.Tiger_ToastError_WebPageUrlError)
            }
        case "3":
            print("第三種")
            hostView.mainViewDirectToLinkWeb(withMethod: .Link3_WebContent, withObject: self.promotionsListData)
        default:
            break
        }
        
	}
    override func awakeFromNib() {
        super.awakeFromNib()
		backgroundWhiteView.layer.borderWidth = 1
		backgroundWhiteView.layer.borderColor = UIColor.lightGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
