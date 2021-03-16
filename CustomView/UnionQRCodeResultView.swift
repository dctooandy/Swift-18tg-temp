//
//  UnionQRCodeResultContainerView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
class UnionQRCodeResultView: UIView , Nibloadable
{
    var countDownInt : Int = 300
    var hostView : ViewController!
    let countDownTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    @IBOutlet var qrcodeContainerView : UIView!
    @IBOutlet var qrcodeImageView : UIImageView!
    @IBOutlet var timerLabel : UILabel!
    @IBOutlet var amountLabel : UILabel!
    @IBOutlet var transitionLabel : UILabel!
    @IBOutlet var dismissAndContinueButton : UIButton!
    @IBOutlet var checkListButton : UIButton!
    // 銀聯QRCodeData
    private var _unionQRCodeSuccessDataAtResultView : HG_PaymentPayThirdpayDto!
    var unionQRCodeSuccessDataAtResultView : HG_PaymentPayThirdpayDto!
    {
        get{
            return _unionQRCodeSuccessDataAtResultView
        }
        set{
            _unionQRCodeSuccessDataAtResultView = newValue
            if _unionQRCodeSuccessDataAtResultView != nil
            {
                self.setupUnionQRCodeResultView()
            }
            else
            {
//                qrcodeImageView.image = UIImage.init(qrCode: "https://www.google.com", size: qrcodeImageView.frame.size.height)
            }
        }
    }
    override func awakeFromNib()
    {
        qrcodeContainerView.layer.borderColor = UIColor.lightGray.cgColor
        qrcodeContainerView.layer.borderWidth = 1
        dismissAndContinueButton.layer.borderColor = Themes.lineBlueColor.cgColor
        dismissAndContinueButton.layer.borderWidth = 1
        dismissAndContinueButton.setTitleColor(Themes.lineBlueColor, for: .normal)
        checkListButton.backgroundColor = Themes.lineBlueColor
    }
    @IBAction func dismissViewAction(_ sender : UIButton?)
    {
        countDownTimer.cancel()
        hostView.scrollToTop()
        unionQRCodeSuccessDataAtResultView = nil
        hostView.hgServiceUnionQRCodeSuccessData = nil
        self.superview?.isHidden = true
        self.removeFromSuperview()
        
    }
    @IBAction func checkListAction(_ sender : UIButton?)
    {
//        hostView.scrollToTop()
//        unionQRCodeSuccessDataAtResultView = nil
//        hostView.hgServiceUnionQRCodeSuccessData = nil
//        self.superview?.isHidden = true
//        self.removeFromSuperview()
        countDownTimer.cancel()
        dismissViewAction(nil)
        hostView.directToVC(type: 3)
        // 加入CheckList Mode
//        hostView.mainViewDirectToSaveTransOut()
    }
    func setupUnionQRCodeResultView()
    {
        deadLineTimerAction()
        setQRCodeImage()
        amountLabel.text = unionQRCodeSuccessDataAtResultView.data?.Amount
        transitionLabel.text = unionQRCodeSuccessDataAtResultView.data?.OrderId
    }
    func setQRCodeImage()
    {
        let utf8str = unionQRCodeSuccessDataAtResultView.data?.base64ImgString
        let cutString = "data:image/png;base64, "
        let start = utf8str!.index(utf8str!.startIndex, offsetBy: cutString.count)
        let range = start..<utf8str!.endIndex
        let mySubstring :String = String(utf8str![range])
        // 将 base64的图片字符串转化成Data
        let imageData = Data(base64Encoded: mySubstring)
        // 将Data转化成图片
        let image = UIImage(data: imageData!)
        qrcodeImageView.image = image
    }
    func deadLineTimerAction()
    {
        DispatchTimer(timeInterval: 1, repeatCount: countDownInt) { (timer, count) in
            print("剩餘執行次數 = \(count)")
            
//            self.timerLabel.text = String(count) + "秒"
            self.timerLabel.text = " \(count/60) 分 \(count % 60) 秒"

        }
        DispatchAfter(after: Double(countDownInt))
        {
           self.timerLabel.text = "已过期"
        }

    }
    func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
    {
        if repeatCount <= 0 {
            return
        }
        var count = repeatCount
        countDownTimer.schedule(wallDeadline: .now(), repeating: timeInterval)
        countDownTimer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(self.countDownTimer, count)
            }
            if count == 0 {
                self.countDownTimer.cancel()
            }
        })
        countDownTimer.resume()
        
    }
    public func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
 
}
