//
//  LinkMethodTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/27.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
class LinkMethodTableViewCell: UITableViewCell  , UIScrollViewDelegate
{
    private lazy var inboxWebView : WKWebView = {
        let webview = WKWebView()
        webview.navigationDelegate = self
        webview.scrollView.delegate = self
        return webview
    }()
    
    @IBOutlet var mainTitleLabel : UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var inboxMailTitleView : UIView!
    @IBOutlet var promotionsTitleView : UIView!
    @IBOutlet var contentImageView : UIImageView!
    @IBOutlet var promotionsNameLabel : UILabel!
    var superTableView: UITableView!
    var promotionTitleViewIsShow : Bool! = false
    var inboxMailTitleViewIsShow : Bool! = false
    private var _promotionsListData : HG_PromotionsListData?
    
    var promotionsListData : HG_PromotionsListData!
    {
        get
        {
         return _promotionsListData
        }
        set
        {
            _promotionsListData = newValue
            OperationQueue.main.addOperation
                {
                    self.promotionTitleViewIsShow = true
                    self.inboxMailTitleViewIsShow = false
                    self.inboxMailTitleView.isHidden = true
                    self.promotionsTitleView.isHidden = false
                    
                    var promotionsTitleViewFrame = self.promotionsTitleView.frame
                    promotionsTitleViewFrame.size.width = self.frame.size.width
                    self.promotionsTitleView.frame = promotionsTitleViewFrame
                    
                    self.inboxWebView.scrollView.bounces = false
                    
                    self.contentImageView.sdLoad(with: URL(string: (self._promotionsListData?.Images)!))
                    self.promotionsNameLabel.text = self._promotionsListData?.PromotionsName
                    self.inboxWebView.scrollView.contentInset = UIEdgeInsets(top: self.promotionsTitleView.frame.size.height, left: 0, bottom: 0, right: 0)
                    if let content = self._promotionsListData?.Content {
                        self.inboxWebView.loadHTMLWithDefaultCsStyle(content: content, baseURL: nil)
                    }
            }
        }
    }
    private var _inboxMailData : HG_MemberInBoxData?
    var inboxMailData : HG_MemberInBoxData?
    {
        get {
            return _inboxMailData
        }
        set {
            _inboxMailData = newValue
            OperationQueue.main.addOperation {
                self.promotionTitleViewIsShow = false
                self.inboxMailTitleViewIsShow = true
                self.inboxMailTitleView.isHidden = false
                self.promotionsTitleView.isHidden = true
                self.inboxWebView.scrollView.bounces = false
                
                self.mainTitleLabel.text = self._inboxMailData?.Title
                self.timeLabel.text = self._inboxMailData?.SendTime_At
                
                self.inboxWebView.scrollView.contentInset = UIEdgeInsets(top: self.inboxMailTitleView.frame.size.height, left: 0, bottom: 0, right: 0)
//                self.insertInboxMailTitleView()
                if let content = self._inboxMailData?.Content {
                    self.inboxWebView.loadHTMLWithDefaultCsStyle(content: content, baseURL: Bundle.main.bundleURL)
                }
            }
        }
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        setupInboxWebView()
        
        // Initialization code
    }
    
    private func setupInboxWebView() {
        contentView.insertSubview(inboxWebView, at: 0)
        inboxWebView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func webViewDidStartLoad(_ webView: UIWebView)
//    {
//        print("loading")
//    }
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
//    {
//        if request.url?.absoluteString.contains("https") == true
//        {
//            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
//            return false
//        }else
//        {
//            return true
//        }
//    }
    func insertInboxMailTitleView(_ currentView : UIView)
    {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                currentView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    func animationForInboxMailTitleView(_ currentView : UIView)
    {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let translateTransform = CGAffineTransform.init(translationX: 0, y: -currentView.frame.size.height)
                currentView.transform = translateTransform
                
        }, completion:nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height
        {
            print("到底了")
//            if (promotionTitleViewIsShow == true)
//            {
//                promotionTitleViewIsShow = false
//                animationForInboxMailTitleView(promotionsTitleView)
//            }
            
        }else
        {
            if (scrollView.contentOffset.y <= 0 ) && (scrollView.contentOffset.y >= -324 )
            {
                print("DidScroll 向下拉到")
//                if promotionTitleViewIsShow == false
//                {
//                    promotionTitleViewIsShow = true
//
//                    insertInboxMailTitleView(promotionsTitleView)
//                }
                var newFrame = promotionsTitleView.frame
                newFrame.origin.y = (-324 - scrollView.contentOffset.y)
                promotionsTitleView.frame = newFrame
            }
//            if scrollView.contentOffset.y > 0
//            {
//                print("DidScroll 向上拉到")
//                if (promotionTitleViewIsShow == true)
//                {
//                    promotionTitleViewIsShow = false
//                    animationForInboxMailTitleView(promotionsTitleView)
//                }
//            }
            
            
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        print("停止滑動")
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height
        {
            print("正在到底了")
            superTableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .bottom, animated: true)
        }else
        {
            print("不在底部")
//            superTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
    }
}

extension LinkMethodTableViewCell:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url , url.absoluteString.contains("https") == true
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }else
        {
            decisionHandler(.allow)
        }
    }
}
