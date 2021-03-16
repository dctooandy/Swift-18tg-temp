//
//  ModifyBaseUserInfoTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PGDatePicker
import PGPickerView

protocol ModifyBaseUserInfoTableViewCellDelegate:class {
    func updateUserRealName(realName:String)
    func updateUserBirthday(birthday:String)
}

class ModifyBaseUserInfoTableViewCell: UITableViewCell {
    enum InfoMode {
        case name(String?)
        case birthday(String?)
    }
    enum FilledMode {
        case new
        case filled
    }
    private var infoMode:InfoMode = .name(nil) {
        didSet{
            switch infoMode {
            case let .name(value):
                canShowDate(false)
                if let name = value {
                    baseInfoTextField.text = name
                    baseInfoTextField.isEnabled = false
                } else {
                    baseInfoTextField.isEnabled = true
                }
                baseInfoTextField.placeholder = "姓名"
                hintLabel.text = nameWarning
                downArrowImageView.isHidden = true
            case let .birthday(value):
                if let birthday = value {
                    baseInfoTextField.text = birthday
                    baseInfoTextField.isEnabled = false
                } else {
                    baseInfoTextField.isEnabled = true
                }
                canShowDate(true)
                baseInfoTextField.placeholder = "选择生日"
                hintLabel.text = birthdayWarning
                downArrowImageView.isHidden = false
            }
        }
    }
    private var filledMode:FilledMode = .new {
        didSet {
            switch filledMode {
            case .new:
                submitButton.setTitle("提交", for: .normal)
                baseInfoTextField.backgroundColor = .white
            case .filled:
                submitButton.setTitle("联系客服修改", for: .normal)
                canShowDate(false)
                baseInfoTextField.backgroundColor = Themes.textFieldDisableColor
            }
        }
    }
    private let adultWarning = "对不起，本网站只对年满18周岁服务，请输入正确生日，我们将为VIP会员派发生日礼金"
    private let birthdayWarning = "＊注意：输入正确的生日才可派发 VIP 会员生日礼金。"
    private let nameWarning = "＊注意：姓名需与提款银行户名相同才能提款。"
    @IBOutlet var baseInfoTextField:UITextField!
    @IBOutlet var downArrowImageView:UIImageView!
    @IBOutlet var hintLabel:UILabel!
    @IBOutlet var submitButton:UIButton!
    private let tap = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()
    
    weak var hostView:ViewController?
    weak var delegate:ModifyBaseUserInfoTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        bindSubmitBtn()
        bindGesture()
        canShowDate(false)
        NotificationCenter.default.addObserver(self, selector: #selector(pickDate), name: NotifyConstant.birthdayDatePicker, object: nil)
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe({ [weak self] _ in
            self?.contentView.endEditing(true)
        } ).disposed(by: disposeBag)
        
        // Initialization code
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bindSubmitBtn(){
        submitButton.rx.tap.subscribe(onNext: { [weak self]_ in
            guard let weakSelf = self else { return }
            
            switch weakSelf.filledMode{
            case .new:
                guard let text = weakSelf.baseInfoTextField.text, text != "" else {
                        weakSelf.hostView?.showErrorToast(with: "资料不得为空")
                        return
                }
                switch weakSelf.infoMode {
                case .name(_):
                    weakSelf.delegate?.updateUserRealName(realName: text)
                case .birthday(_):
                    weakSelf.delegate?.updateUserBirthday(birthday: text)
                }
            case .filled:
                LiveChatService.share.presentLiveChat()
            }
        } ).disposed(by: disposeBag)
    }
    
    private func bindGesture(){
        baseInfoTextField.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { [weak self]_ in
            self?.showDatePicker()
        }).disposed(by: disposeBag)
    }
    
    private func showDatePicker(){
        let datePickerManager = PGDatePickManager()
        datePickerManager.isShadeBackground = true
        let datePicker = datePickerManager.datePicker!
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.minimumDate = DateComponents(calendar: Calendar.current, year: 1900, month: 1, day: 1, hour: 1, minute: 1, second: 1).date
        if let delegate = hostView as? PGDatePickerDelegate {
            datePicker.delegate = delegate
        }
        hostView?.present(datePickerManager, animated: false, completion: nil)
    }
    
    func settingMode(infoMode:InfoMode , filledMode:FilledMode)  {
        baseInfoTextField.text = ""
        self.infoMode = infoMode
        self.filledMode = filledMode
        
    }
    
    private func canShowDate(_ bool:Bool){
        tap.isEnabled = bool
    }
    
    @objc func pickDate(notify: NSNotification) {
        if let components = notify.object as? DateComponents {
            let month = components.month ?? 0
            let day = components.day ?? 0
            let userMonth = month<10 ? "0\(month)" : "\(month)"
            let userDay = day<10 ? "0\(day)" : "\(day)"
            baseInfoTextField.text = "\(components.year ?? 00)-\(userMonth)-\(userDay)"
            isAllowSubmit()
        }
    }
    
    private func isAllowSubmit(){
      let isAdult =  DateHelper.share.checkIsAdult(date: baseInfoTextField.text ?? "")
        hintLabel.text = isAdult ? birthdayWarning : adultWarning
        submitButton.isEnabled = isAdult
    }
}
