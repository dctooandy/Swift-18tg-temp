//
//  CalendarView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/5.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate: class{
    func pick(startDate:String , endDate:String)
}

class CalendarView: UIView , Nibloadable 
{
    @IBOutlet var startCalendar : UIDatePicker!
    @IBOutlet var endCalendar : UIDatePicker!
    @IBOutlet var startTimeLabel : UILabel!
    @IBOutlet var endTimeLabel : UILabel!
    @IBOutlet var confirmButton : UIButton!
    @IBOutlet var cancelButton : UIButton!

    var currentReceivePrizeMode : ReceivePrizeFlag!
    var currentCashflowReciordMode : CashflowRecordFlag!
    weak var delegate:CalendarViewDelegate?

    var hostView : ViewController!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setCurrentDateToLabel()
    {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        startCalendar.setDate(previousMonth!, animated: true)
        endCalendar.setDate(Date(), animated: true)
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy-MM-dd"
        startTimeLabel.text = dateValue.string(from: startCalendar.date)
        endTimeLabel.text = dateValue.string(from: endCalendar.date)
        // 領獎
        hostView.returnWaterCalendarDateArray = [startTimeLabel.text, endTimeLabel.text] as! Array<String>
        hostView.setReceivePrizeCellDateLabel()
        // 資金紀錄
        hostView.cashflowRecordCalendarDateArray = [startTimeLabel.text, endTimeLabel.text] as! Array<String>
        hostView.setCashflowRecordCellDateLabel()
    }
    func setCalendarMinAndMaxDate()
    {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.month = -6
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        startCalendar.minimumDate = minDate
        startCalendar.maximumDate = currentDate
        endCalendar.minimumDate = minDate
        endCalendar.maximumDate = currentDate
    }
    func animationForCalendarView()
    {
        setCalendarMinAndMaxDate()
        hostView.removeBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let startTransform = CGAffineTransform.init(translationX: 0, y: self.frame.size.height + self.hostView.view.frame.size.height + 100)
                self.hostView.calendarContainerView.transform = startTransform
            
        }, completion:nil)
        
    }
    func insertForReceivePrizeCalendarView(_ flag : ReceivePrizeFlag)
    {
        currentReceivePrizeMode = flag
        currentCashflowReciordMode = .None
        hostView.addBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.customNavigationView.cnViewLeftBarButton.isEnabled = false
                self.hostView.calendarContainerView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    func insertForCashflowRecordCalendarView()
    {
        currentReceivePrizeMode = .None
        currentCashflowReciordMode = hostView.currentCashflowRecordFlag
        hostView.addBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.customNavigationView.cnViewLeftBarButton.isEnabled = false
                self.hostView.calendarContainerView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    @IBAction func confirmAction(_ sender : UIButton)
    {
        if (startCalendar.date.compare(endCalendar.date) == .orderedSame) ||
            (startCalendar.date.compare(endCalendar.date) == .orderedDescending)
        {
            hostView.showErrorToast(with: "时间设定错误")
        }else
        {
            hostView.customNavigationView.cnViewLeftBarButton.isEnabled = true
            if currentReceivePrizeMode == .None
            {// 資金紀錄
                print("資金紀錄mode")
                let startTimeString = startTimeLabel.text!
                let endTimeString = endTimeLabel.text!
                hostView.cashflowRecordCalendarDateArray = [startTimeLabel.text, endTimeLabel.text] as! Array<String>
                hostView.setCashflowRecordCellDateLabel()
                animationForCalendarView()
                switch currentCashflowReciordMode
                {
                case .All? :
                    hostView.getCashLogAll(startDate: startTimeString, endDate: endTimeString, page: "1", more : false)
                case .SaveMoney? :
                    hostView.getQueryOrderForSaveCashOutMoney(PayType: "1", startDate: startTimeString, endDate: endTimeString, page: "1", more : false)
                case .CashOut? :
                    hostView.getQueryOrderForSaveCashOutMoney(PayType: "2", startDate: startTimeString, endDate: endTimeString, page: "1", more : false)
                case .TransMoney? :
                    hostView.getCashLogTrans(startDate: startTimeString, endDate: endTimeString, page: "1", more : false)
                default :
                    break
                }
                
                
            }else if currentReceivePrizeMode == .UserBetRecord{
             delegate?.pick(startDate: startTimeLabel.text ?? "0000-00-00", endDate: endTimeLabel.text ?? "0000-00-00")
             animationForCalendarView()
            } else
            {// 領獎
                print("領獎mode")
                hostView.returnWaterCalendarDateArray = [startTimeLabel.text, endTimeLabel.text] as! Array<String>
                hostView.setReceivePrizeCellDateLabel()
                animationForCalendarView()
                hostView.getReceivePrize(flag: currentReceivePrizeMode, startDate: startTimeLabel.text!, endDate: endTimeLabel.text!, page: "1" ,gameGroupId: hostView.receivePrizeGameGroupIDString)
            }
        }
        
    }
    @IBAction func cancelAction(_ sender: UIButton)
    {
        hostView.customNavigationView.cnViewLeftBarButton.isEnabled = true
        setCurrentDateToLabel()
        animationForCalendarView()
    }
    @IBAction func startDatePickerAction(_ sender : UIDatePicker)
    {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy-MM-dd"
        startTimeLabel.text = dateValue.string(from: sender.date)
    }
    @IBAction func endDatePickerAction(_ sender : UIDatePicker)
    {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy-MM-dd"
        endTimeLabel.text = dateValue.string(from: sender.date)
    }
}
