//
//  ChangePasswordTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/19.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


protocol ChangePasswordTableViewCellDelegate:class {
    func submitTapAction(oldPassword:String, newPassword:String)
}


class ChangePasswordTableViewCell: UITableViewCell {
   
    @IBOutlet var currentPassWordTextField : UITextField!
    @IBOutlet var newPassWordTextField : UITextField!
    @IBOutlet var confirmPassWordTextField : UITextField!
    @IBOutlet var currentPassWordHintLabel : UILabel!
    @IBOutlet var newPassWordHintLabel : UILabel!
    @IBOutlet var confirmPassWordHintLabel : UILabel!
    @IBOutlet var submitButton : UIButton!
    weak var delegate:ChangePasswordTableViewCellDelegate?
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        submitButton.isEnabled = false
        bindUI()
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe({ [weak self] _ in
            self?.contentView.endEditing(true)
        } ).disposed(by: disposeBag)
        

        // Initialization code
    }
    
    private func bindUI(){
        
        currentPassWordTextField.rx.text.orEmpty.asObservable().map(isPasswordLenthValid)
        .bind(to: currentPassWordHintLabel.rx.isHidden)
        .disposed(by: disposeBag)

        newPassWordTextField.rx.text.orEmpty.asObservable().map(isPasswordLenthValid)
            .bind(to: newPassWordHintLabel.rx.isHidden)
            .disposed(by: disposeBag)

        confirmPassWordTextField.rx.text.orEmpty.asObservable().map({ text -> Bool in
            return text.count == 0})
            .bind(to: confirmPassWordHintLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        let rxPasswords = Observable.combineLatest([newPassWordTextField.rx.text.orEmpty.asObservable() , confirmPassWordTextField.rx.text.orEmpty.asObservable()]).share()
        
            rxPasswords
            .map(hintText)
            .bind(to: confirmPassWordHintLabel.rx.text)
            .disposed(by: disposeBag)
        
        rxPasswords.map {[weak self] (passwords) -> Bool in
            guard let weakSelf = self else { return false}
            let oldPassWord = passwords.first ?? ""
            let newPassWord = passwords.last ?? ""
            let isShowHint = weakSelf.currentPassWordHintLabel.isHidden &&
            weakSelf.newPassWordHintLabel.isHidden
            return (oldPassWord == newPassWord) && isShowHint}
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        currentPassWordHintLabel.isHidden = true
        newPassWordHintLabel.isHidden = true
        
        
        submitButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let weakSelf = self ,
                let oldPassword = weakSelf.currentPassWordTextField.text,
                let newPassword = weakSelf.confirmPassWordTextField.text  else {return}
            weakSelf.delegate?.submitTapAction(oldPassword: oldPassword, newPassword: newPassword)
        })
            .disposed(by: disposeBag)
    }
    
    func clearAllTextfield(){
        currentPassWordTextField.text = ""
        newPassWordTextField.text = ""
        confirmPassWordTextField.text = ""
        currentPassWordHintLabel.isHidden = true
        newPassWordHintLabel.isHidden = true
        confirmPassWordHintLabel.isHidden = true
        
    }
    
    private func isPasswordLenthValid(text:String)->Bool {
        let count = text.count
        if (count > 20 || count < 8) {
            return false
        }
        return true
    }
    
    private func hintText(passwords:[String]) -> String {
        let oldPassWord = passwords.first ?? ""
        let newPassWord = passwords.last ?? ""
        
        if isPasswordLenthValid(text:newPassWord) {
            return oldPassWord == newPassWord ? "" : "两次输入密码不一致！"
        } else {
            return "请输入新密码"
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
