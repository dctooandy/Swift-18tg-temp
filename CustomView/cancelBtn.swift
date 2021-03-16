//
//  cancelBtn.swift
//  ProjectT
//
//  Created by vanness wu on 2019/5/10.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit

class CancelBtn:UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius(radius: frame.height/2)
    }
    private let icon = UIImageView(image: UIImage(named: "icon-cancel"))
    private func setupUI(){
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        let margin = frame.height/5
        icon.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
        }
        backgroundColor = .lightGray
        alpha = 0.5
    }
    
}
