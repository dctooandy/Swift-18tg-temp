//
//  UserBetCalendarTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/25.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UserBetCalendarTableViewCell: UITableViewCell {

    var hostView : ViewController!
    @IBOutlet var dateDiscriptionView : UIView!
    @IBOutlet var dateDiscriptionLabel : UILabel!
    private let disposeBag = DisposeBag()
    override func awakeFromNib()
    {
        super.awakeFromNib()
        bindTap()
        NotificationCenter.default.rx
            .notification(NotifyConstant.userBetCalendar)
            .takeUntil(self.rx.deallocated)
            .subscribe{ [weak self] notify in
                if let dates = notify.element?.object as? (String,String) {
                    self?.setDateLabel(dates: dates)
                }
            }.disposed(by: disposeBag)
        setDateLabel(dates: (DateHelper.share.aMonthAgo(),DateHelper.share.dateString()))
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func bindTap() {
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe ({ [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.hostView.calendarInnerView.insertForReceivePrizeCalendarView(weakSelf.hostView.calendarInnerView.currentReceivePrizeMode)
        }).disposed(by: disposeBag)
    }
    
    func setDateLabel(dates:(String,String)) {
         dateDiscriptionLabel.text = "\(dates.0) ~ \(dates.1)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
