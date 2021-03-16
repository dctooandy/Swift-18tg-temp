//
//  CustomNavigationView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/23.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class CustomNavigationView: UIView
{
    @IBOutlet var cnViewLeftBarButton : UIButton!
    @IBOutlet var cnViewRightBarButton : UIButton!
    @IBOutlet var cnViewTitleLabel : UILabel!
    @IBOutlet var gradientLayerView : UIView!
    var vcDelegate : CustomNavigationTapDelegate!
	var hostView : ViewController!
    private let disposeBag = DisposeBag()
    class func instanceFromNib(withDelegate delegate : ViewController) -> CustomNavigationView
    {
        let customNavigationView = UINib(nibName: "CustomNavigationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomNavigationView
        customNavigationView.vcDelegate = delegate
        customNavigationView.setupLayerView()
        customNavigationView.bindRightBtn()
        return customNavigationView
    }
    
    private func bindRightBtn(){
        cnViewRightBarButton.rx.tap.subscribe{ _ in
            LiveChatService.share.presentLiveChat()
        }.disposed(by: disposeBag)
    }
    
    func setupLayerView()
    {
        gradientLayerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientLayerView.bounds
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.yellow.cgColor,UIColor.yellow.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0, 0.35,0.65, 1]
        gradientLayerView.layer.addSublayer(gradientLayer)
    }

    @IBAction func buttonDidTaped(_ sender : UIButton)
    {
        vcDelegate.userTapCustomNavigation(at: sender)
    }
	func insertCustomNavigationContainerView()
	{
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				self.hostView.customNavigationContainerView.transform = CGAffineTransform.identity
		}, completion:nil)
	}
	func animationForCustomNavigationContainerView()
	{
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				let translateTransform = CGAffineTransform.init(translationX: self.hostView.view.frame.size.width, y: 0)
				self.hostView.customNavigationContainerView.transform = translateTransform
				
		}, completion:nil)
	}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
