//
//  PersonalInfoTableViewCell.swift
//  ProjectT
//
//  Created by vanness wu on 2019/3/20.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PersonalInfoTableViewCell:UITableViewCell {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var detailLabel:UILabel!
    private(set) var info:Info = .name
    weak var hostView:ViewController!
    enum Info {
        case name,birthday,phone,email
        
    }
    
    private let disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        bindUI()
    }
    
    func configureCell(title:String, detail:String , info:Info){
        titleLabel.text = title
        detailLabel.text = detail
        self.info = info
    }
    
    private func bindUI(){
        let tap = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: {[weak self] _ in
            guard let weakSelf = self else {return}
            switch weakSelf.info {
            case .name:
                weakSelf.hostView?.mainViewDirectToModifyUserName()
            case .birthday:
                weakSelf.hostView?.mainViewDirectToModifyUserBirthday()
            case .phone:
                weakSelf.hostView?.mainViewDirectToVerifyUserPhone()
            case .email:
                weakSelf.hostView?.mainViewDirectToVerifyUserEmail()
            }
        }).disposed(by: disposeBag)
    }
}
