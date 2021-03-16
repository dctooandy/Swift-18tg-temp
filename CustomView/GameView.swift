//
//  GameView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/13.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import JavaScriptCore

class GameView: UIView , Nibloadable 
{
    
    @IBOutlet var dismissBtn:UIButton!
    var hostView : ViewController!
    private lazy var gameWebView : WKWebView = {
        let wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: Views.screenWidth, height: Views.screenHeight))
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        return wkWebView
    }()
    var ptTempUrl = ""
    var isLoading = false
    private var _urlString :String!
    
    var urlString : String!
    {
        get{
            return _urlString
        }
        set{
            _urlString = newValue
            gameWebView.load(URLRequest(url: URL(string: _urlString)!))
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setupWkwebView()
        dismissBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    private func setupWkwebView() {
        insertSubview(gameWebView, at: 0)
        gameWebView.snp.makeConstraints{maker  in
         maker.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func animationForGameWebContainerView()
    {
        hostView.removeBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let startTransform = CGAffineTransform.init(translationX: 0, y: self.frame.size.height + self.hostView.view.frame.size.height + 100)
                self.hostView.gameWebContainerView.transform = startTransform
                self.hostView.gameWebContainerView.isHidden = true
                
        }, completion: { _ in
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        })
        
    }
    func insertForGameWebContainerView()
    {
        hostView.addBlurView()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.gameWebContainerView.transform = CGAffineTransform.identity
                self.hostView.gameWebContainerView.isHidden = false
        }, completion:nil)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func dismissbuttonAction(_ sender : UIButton)
    {
        print("遊戲頁面消失")
        animationForGameWebContainerView()
        gameWebView.load(URLRequest(url: URL(string: "about:blank")!))
    }
    // UIWebView Delegate
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
//        webView.stringByEvaluatingJavaScript(from: "window.location.login()")
//        let jsStr_2 = "var p = document.getElementsByTagName('p')[0];"
//        let jsStr_3 = "p.innerHTML = '使用JavaScript很🐂';"
//        let jsStr_4 = "p.style.background = 'red';document.body.appendChild(p);"
//        webView.stringByEvaluatingJavaScript(from: jsStr_2)
//        webView.stringByEvaluatingJavaScript(from: jsStr_3)
//        webView.stringByEvaluatingJavaScript(from: jsStr_4)
//        
//        let jsStr_5 = "var li = document.createElement('li');li.innerHTML='执行js代码，dom操作元素';li.style.background = 'gray';document.body.appendChild(li);"
//        webView.stringByEvaluatingJavaScript(from: jsStr_5)
        
//        let jsStr_1 = "alert('JS弹框')"
//        webView.stringByEvaluatingJavaScript(from: jsStr_1)
//        webView.stringByEvaluatingJavaScript(from: "launchMobileClient()")
//        webView.stringByEvaluatingJavaScript(from: "calloutGetTemporaryAuthenticationToken()")
//        webView.stringByEvaluatingJavaScript(from: "calloutLogin()")
//        webView.stringByEvaluatingJavaScript(from: "iapiLogin('\(accountIDString)','\(passwordString)','1','zh-cn')")
//        let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
//        jsContext?.objectForKeyedSubscript("iapiLogin")!.call(withArguments: ["\(accountIDString)","\(passwordString)","1","zh-cn"])
    }
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
//    {
//
//        return true
//    }
}

extension GameView:WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hostView.showToast(message: error.localizedDescription)
        print("didFail===========>\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hostView.showToast(message: error.localizedDescription)
        print("didFailProvisionalNavigation===========>\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("alert message===========>\(message)")
       let alertVC =  UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        hostView.present(alertVC, animated: true, completion: nil)
        completionHandler()
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVC =  UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            completionHandler(true)
        }
        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        hostView.present(alertVC, animated: true, completion: nil)
    }
    
//    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        print("redict")
//    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        print("policy \(navigationResponse)")
//        decisionHandler(.allow)
//    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("action")
//        print(navigationAction.request.url)
//        decisionHandler(.allow)
//    }
    
}
