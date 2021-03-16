//
//  NotifySettingTableViewCell.swift
//  ProjectT
//
//  Created by Victor on 2019/4/3.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class NotifySettingTableViewCell: UITableViewCell {
    var hostView : ViewController!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var depositAndWithdrawalSwitch: UISwitch!
    @IBOutlet weak var newOfferSwitch: UISwitch!
    @IBOutlet weak var inboxMailSwitch: UISwitch!
    @IBOutlet weak var systemMessageSwitch: UISwitch!
    
    
    
    @IBAction func depositAndWithdrawalSwitchPressed(_ sender: UISwitch) {
        hostView.notifySetting.deposit = sender.isOn
    }
    @IBAction func newsOfferSwitchPressed(_ sender: UISwitch) {
        hostView.notifySetting.offer = sender.isOn
    }
    @IBAction func inboxMailSwitchPressed(_ sender: UISwitch) {
        hostView.notifySetting.mail = sender.isOn
    }
    @IBAction func systemMessageSwitchPressed(_ sender: UISwitch) {
        hostView.notifySetting.systemMsg = sender.isOn
    }
    
    @IBAction func notifySwitchPressed(_ sender: UISwitch) {
        let isOn = sender.isOn
        hostView.notifySetting.all = isOn
        changeAllSwitchStatus(to: isOn)
        if isOn {
            UIApplication.shared.registerForRemoteNotifications()
            return
        }
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func changeAllSwitchStatus(to status: Bool) {
        
        depositAndWithdrawalSwitch.isEnabled = status
        newOfferSwitch.isEnabled = status
        inboxMailSwitch.isEnabled = status
        systemMessageSwitch.isEnabled = status
        depositAndWithdrawalSwitch.isOn = status
        newOfferSwitch.isOn = status
        inboxMailSwitch.isOn = status
        systemMessageSwitch.isOn = status
        hostView.notifySetting.systemMsg = status
        hostView.notifySetting.mail = status
        hostView.notifySetting.offer = status
        hostView.notifySetting.deposit = status
    
    }
 
    func setup() {
        
        notifySwitch.isOn = hostView.notifySetting.all
        depositAndWithdrawalSwitch.isOn = hostView.notifySetting.deposit
        newOfferSwitch.isOn = hostView.notifySetting.offer
        inboxMailSwitch.isOn = hostView.notifySetting.mail
        systemMessageSwitch.isOn = hostView.notifySetting.systemMsg
        changeAllSwitchStatus(to: hostView.notifySetting.all)
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

