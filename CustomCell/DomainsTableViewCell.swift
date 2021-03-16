//
//  DomainsTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/4/9.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class DomainsTableViewCell: UITableViewCell
{
    @IBOutlet var touchButton : UIButton!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    var hostView : ViewController!
    private var _domainData : HG_DomainsDataDto!
    var domainData : HG_DomainsDataDto!
    {
        get{
            return _domainData
        }
        set{
            _domainData = newValue
            setupDomainCellUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupDomainCellUI()
    {
        let date = Date()
        let nowTimeS = date.timeIntervalSince1970
        var str = ""
        if hostView.reachability?.connection.hashValue == 0 {
            print("no internet connected.")
        }else {
            print("internet connected successfully.")
            let dateNew = Date()
            let newTimeS = dateNew.timeIntervalSince1970
            let theTimeS = newTimeS - nowTimeS
            let ms = TimeInterval(theTimeS * 1000)
            str = String(format:"%.3f",ms)
            //            let seconds = ti % 60
            print("time : \(str)")
        }
        nameLabel.text = domainData.name
        timeLabel.text = str + "秒"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
