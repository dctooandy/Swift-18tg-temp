//
//  PopupView.swift
//  ProjectT
//
//  Created by 陳柏元 on 2019/2/28.
//  Copyright © 2019年 Andy Chen. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
class PopupView: UIView, UIWebViewDelegate,UIScrollViewDelegate
{
     lazy var popupWebview : WKWebView = {
       let webview = WKWebView()
        webview.scrollView.delegate = self
        webview.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        webview.navigationDelegate = self
        return webview
    }()
	@IBOutlet var dismissWebviewButton : UIButton!
	var isbottomViewShow : Bool = false
	@IBOutlet var bottomView : UIView!
	@IBOutlet var confirmBoutton : UIButton!
	var hostView : ViewController!
	class func instanceFromNib(withDelegate delegate : ViewController) -> PopupView
	{
		let popupView = UINib(nibName: "PopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PopupView
		popupView.setupBottomView()
		
		return popupView
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupWebView()
    }
    
    private func setupWebView(){
        insertSubview(popupWebview, at: 0)
        popupWebview.snp.makeConstraints { (maker) in
          maker.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
	func setupBottomView()
	{
		bottomView.backgroundColor = UIColor.white
		let translateTransform = CGAffineTransform.init(translationX: 0, y: self.frame.maxY + bottomView.frame.size.height)
		bottomView.transform = translateTransform
		self.addSubview(bottomView)
	}
	func insertButtomView()
	{
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				self.bottomView.transform = CGAffineTransform.identity
		}, completion:nil)
	}
	func resetBottomView()
	{
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				let translateTransform = CGAffineTransform.init(translationX: 0, y: self.frame.maxY + self.bottomView.frame.size.height)
				self.bottomView.transform = translateTransform
				
		}, completion:nil)
	}
	
	@IBAction func dismissAction(_ sender : UIButton)
	{
		
		self.animationForPopupContainerView()
		hostView.removeBlurView()
		let theURL = URL(string: "http://")
		let requestObj = URLRequest(url: theURL!)
		
		hostView.popupView.popupWebview.load(requestObj)
	}
	func animationForPopupContainerView()
	{
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				let translateTransform = CGAffineTransform.init(translationX: 0, y: -self.hostView.view.frame.size.height)
				self.hostView.popupContainerView.transform = translateTransform
		}, completion:nil)
	}
	func insertPopupContainerView()
	{
		hostView.addBlurView()
		UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
			{
				self.hostView.popupContainerView.transform = CGAffineTransform.identity
		}, completion:nil)
	}
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	func scrollViewDidScroll(_ scrollView: UIScrollView)
	{
		print("正在滑動")
		if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height
		{
			print("正在到底了")
			if isbottomViewShow == false
			{
				isbottomViewShow = true
				insertButtomView()
			}
		}else
		{
			print("不在底部")
			if isbottomViewShow == true
			{
				isbottomViewShow = false
				resetBottomView()
			}
		}
	}
	@objc func confirmAction(_ sender:UIButton)
	{
		dismissAction(sender)
	}
}

extension PopupView:WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil ,
            let url = navigationAction.request.url ,
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:] , completionHandler: nil)
            decisionHandler(.cancel)
        } else {
        decisionHandler(.allow)
        }
    }
}
