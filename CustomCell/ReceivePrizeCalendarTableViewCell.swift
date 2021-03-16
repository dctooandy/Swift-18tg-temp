//
//  ReceivePrizeCalendarTableViewCell.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/5.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class ReceivePrizeCalendarTableViewCell: UITableViewCell
{
    var hostView : ViewController!
    @IBOutlet var returnWaterDiscriptionLabel : UILabel!
    @IBOutlet var upWhiteView : UIView!
    @IBOutlet var downWhiteView : UIView!
    @IBOutlet var returnWaterAndRescueSelectedLabel : UILabel!
    @IBOutlet var dateDiscriptionView : UIView!
    @IBOutlet var dateDiscriptionLabel : UILabel!
    var status1GameGroup : Array<HG_GamepoolData>!
    var selectedGameData : HG_GamepoolData!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setTapGestureRecognizer()
//        returnWaterDiscriptionLabel.firstlin
        // Initialization code
        
    }
    func setLabelUI(_ mode : ReceivePrizeFlag)
    {
        switch mode
        {
        case .ReturnWater :
            returnWaterDiscriptionLabel.isHidden = false
            upWhiteView.isHidden = false
            returnWaterAndRescueSelectedLabel.isHidden = false
            downWhiteView.isHidden = false
            dateDiscriptionView.isHidden = false
        case .RescueGold :
            returnWaterDiscriptionLabel.isHidden = true
            upWhiteView.isHidden = false
            returnWaterAndRescueSelectedLabel.isHidden = false
            downWhiteView.isHidden = false
            dateDiscriptionView.isHidden = false
            
        case .RedBonus :
            returnWaterDiscriptionLabel.isHidden = true
            upWhiteView.isHidden = true
            returnWaterAndRescueSelectedLabel.isHidden = true
            downWhiteView.isHidden = true
            dateDiscriptionView.isHidden = false
        default :
            break
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setTapGestureRecognizer()
    {
        let returnWaterTaps = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        returnWaterAndRescueSelectedLabel!.addGestureRecognizer(returnWaterTaps)
        let dateTaps = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture2))
        dateDiscriptionView!.addGestureRecognizer(dateTaps)
    }
    @objc func handleTapGesture()
    {
        setupActionsheet()
    }
    @objc func handleTapGesture2()
    {
        let mode : ReceivePrizeFlag = (returnWaterDiscriptionLabel.isHidden == true) ? ((returnWaterAndRescueSelectedLabel.isHidden == true) ? .RedBonus : .RescueGold ) : .ReturnWater
        hostView.calendarInnerView.insertForReceivePrizeCalendarView(mode)
    }
    func setupActionsheet()
    {
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertSheet.addAction(cancelAction)
        
        for i in 0 ..< (status1GameGroup.count + 1)
        {
            var archiveAction : UIAlertAction!
            if i == 0
            {
                archiveAction = UIAlertAction(title: "全部", style: UIAlertAction.Style.default, handler:
                {
                    action in
                    
                    self.returnWaterAndRescueSelectedLabel.text = "全部"
                    self.hostView.receivePrizeGameGroupIDString = ""
                    self.triggerToGetReceivePrizeData()
                })
            }else
            {
                archiveAction = UIAlertAction(title: status1GameGroup[i-1].GroupName, style: UIAlertAction.Style.default, handler:
                    {
                        action in
                        self.selectedGameData = self.status1GameGroup[i-1]
                        self.returnWaterAndRescueSelectedLabel.text = self.status1GameGroup[i-1].GroupName
                        self.hostView.receivePrizeGameGroupIDString = self.status1GameGroup[i-1].GroupId
                        self.triggerToGetReceivePrizeData()
                })
            }
            
            alertSheet.addAction(archiveAction)
        }
        // 3 跳转
        hostView.present(alertSheet, animated: true, completion: nil)
    }
    func triggerToGetReceivePrizeData()
    {
        let startTime : String = hostView.returnWaterCalendarDateArray[0]
        let endTime : String = hostView.returnWaterCalendarDateArray[1]
        hostView.getReceivePrize(flag: hostView.currentReceivePrizeFlag, startDate: startTime, endDate: endTime, page: "1" ,gameGroupId: hostView.receivePrizeGameGroupIDString)
    }
}
