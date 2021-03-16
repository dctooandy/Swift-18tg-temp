//
//  VerifyUserContactInfoTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/22.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol VerifyUserContactInfoTableViewCellDelegate:class {
    func sendPhoneVerifyCode(cell:VerifyUserContactInfoTableViewCell,phone:String)
    func sendEmailVerifyCode(cell:VerifyUserContactInfoTableViewCell,email:String)
    func verifyPhone(code:String , phone:String)
    func verifyEmail(code:String , email:String)
}


class VerifyUserContactInfoTableViewCell: UITableViewCell {
    
    enum Mode {
        case phone(String?)
        case email(String?)
        
        func matchResult(str:String) -> Bool {
            switch self {
            case .email(_):
                return RegexHelper.match(pattern: .mail, input: str )
            case .phone(_):
                return RegexHelper.match(pattern: .phone, input: str )
            }
        }
    }
    
    @IBOutlet var contactInfoTextField:UITextField!
    @IBOutlet var verificationTextField:UITextField!
    @IBOutlet var getCodeBtn:UIButton!
    @IBOutlet var submitBtn:UIButton!
    @IBOutlet var hintLabel:UILabel!
    private var isSending:Bool = false
    weak var delegate:VerifyUserContactInfoTableViewCellDelegate?
    private let disposeBag = DisposeBag()
    private var mode:Mode = .phone(nil) {
        didSet {
            switch mode {
            case .phone(let phone):
                if let phone = phone {
                    contactInfoTextField.text = phone
                } else {
                    contactInfoTextField.text = ""
                    contactInfoTextField.placeholder = "输入手机号码"
                }
                hintLabel.text = "请输入正确的手机号"
            case .email(let email):
                if let email = email {
                    contactInfoTextField.text = email
                } else {
                    contactInfoTextField.text = ""
                    contactInfoTextField.placeholder = "输入邮箱地址"
                }
                hintLabel.text = "邮箱地址不是一个有效的邮箱"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createCornerRadius()
        bindGetCodeBtn()
        bindTextfiled()
        bindSubmitBtn()
        hintLabel.isHidden = true
        
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe({ [weak self] _ in
            self?.contentView.endEditing(true)
        } ).disposed(by: disposeBag)
        
        // Initialization code
    }
    private func bindSubmitBtn(){
        submitBtn.rx.tap.subscribe({ [weak self] _ in
            guard let weakSelf = self ,
                let value = weakSelf.contactInfoTextField.text,
                let code = weakSelf.verificationTextField.text
                else { return}
            switch weakSelf.mode {
            case .email(_):
                weakSelf.delegate?.verifyEmail(code: code, email: value)
            case .phone(_):
                weakSelf.delegate?.verifyPhone(code: code, phone: value)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindTextfiled() {
        contactInfoTextField.rx.text.map({$0 ?? ""})
            .map({self.mode.matchResult(str: $0)})
            .subscribe(onNext: { [weak self] isValid in
                guard let weakSelf = self else { return }
                weakSelf.hintLabel.isHidden = isValid
                weakSelf.submitBtn.isEnabled = isValid
                weakSelf.getCodeBtn.isEnabled = isValid && !weakSelf.isSending
                
            }).disposed(by: disposeBag)
    }
    
    private func initState(){
        let isValid = mode.matchResult(str: contactInfoTextField.text ?? "")
        hintLabel.isHidden = isValid
        submitBtn.isEnabled = isValid
        getCodeBtn.isEnabled = isValid
        verificationTextField.text = ""
        contactInfoTextField.isEnabled = true
        isSending = false
        dispose?.dispose()
        getCodeBtn.setTitle("获取验证码", for: .normal)
    }
    
    private func bindGetCodeBtn(){
        getCodeBtn.rx.tap.throttle(2, scheduler: MainScheduler.instance)
            .subscribe({ [weak self] _ in
            guard let weakSelf = self , let value = weakSelf.contactInfoTextField.text else { return}
            switch weakSelf.mode {
            case .email(_):
                weakSelf.delegate?.sendEmailVerifyCode(cell: weakSelf, email: value)
            case .phone(_):
                weakSelf.delegate?.sendPhoneVerifyCode(cell: weakSelf,phone: value)
            }
        }).disposed(by: disposeBag)
    }
    
    func configureCell(mode:Mode) {
        self.mode = mode
        initState()
    }
    private var dispose:Disposable?
    func startCountDown(){
        isSending = true
        getCodeBtn.isEnabled = false
        contactInfoTextField.isEnabled = false
         let  timer = Observable<Int>
            .timer(0, period: 1, scheduler: MainScheduler.instance)
            .take(90)
       dispose = timer.subscribe(onNext: { [weak self] count in
            guard let weakSelf = self else { return }
            weakSelf.getCodeBtn.setTitle("\(89 - count)秒后重发", for: .normal)
            }, onCompleted: {[weak self] in
                self?.contactInfoTextField.isEnabled = true
                self?.getCodeBtn.isEnabled = true
                self?.isSending = false
                self?.getCodeBtn.setTitle("获取验证码", for: .normal)
        })
    }
    
    private func createCornerRadius(){
        let corners: UIRectCorner = [UIRectCorner.topRight, UIRectCorner.bottomRight]
        let path = UIBezierPath(roundedRect: getCodeBtn.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.frame = bounds
        getCodeBtn.layer.mask = maskLayer
    }
    
    
    
    
}
