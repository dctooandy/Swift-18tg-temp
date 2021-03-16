//
//  NewsTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/27.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell
{
    @IBOutlet var backgroundWhiteView : UIView!
    @IBOutlet var newsTitleLabel : UILabel!
    @IBOutlet var newsContentLabel : UILabel!
    @IBOutlet var updateTimeLabel : UILabel!
	
    var hostView : ViewController!
    private var _newsListData : HG_NewsListData?
    var newsListData : HG_NewsListData!
    {
        get{
            return _newsListData
        }
        set{
            _newsListData = newValue
            self.newsTitleLabel.text = _newsListData?.NewsName
            let removeString = _newsListData?.Content.pregReplace(pattern: "<[^>]*>", with: "")
            self.newsContentLabel.text = removeString
            self.updateTimeLabel.text = _newsListData?.showDate
        }
    }
	@IBAction func cellDidSelected(with sender : UIButton)
	{
		hostView.mainViewDirectToLinkWeb(withMethod: .Link1_Popup, withObject: self.newsListData)
	}
    override func awakeFromNib()
    {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        backgroundWhiteView.layer.borderWidth = 1
        backgroundWhiteView.layer.borderColor = UIColor.lightGray.cgColor
        backgroundWhiteView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroundWhiteView.layer.shadowRadius = 5.0
        backgroundWhiteView.layer.shadowOpacity = 0.5
        backgroundWhiteView.layer.shadowOffset = CGSize(width: 5, height: 5)
        backgroundWhiteView.layer.masksToBounds = false
        newsContentLabel.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
 
}
