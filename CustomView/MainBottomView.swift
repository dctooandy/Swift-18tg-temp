//
//  MainBottomView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/15.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class MainBottomView: UIView , UIGestureRecognizerDelegate
{
    @IBOutlet var button1 : UIButton!
    @IBOutlet var button2 : UIButton!
    @IBOutlet var button3 : UIButton!
    @IBOutlet var button4 : UIButton!
    @IBOutlet var button5 : UIButton!
    
    @IBOutlet var label1 : UILabel!
    @IBOutlet var label2 : UILabel!
    @IBOutlet var label3 : UILabel!
    @IBOutlet var label4 : UILabel!
    @IBOutlet var label5 : UILabel!
    
    @IBOutlet var bottomCoverButton1: UIButton!
    @IBOutlet var bottomCoverButton2: UIButton!
    @IBOutlet var bottomCoverButton3: UIButton!
    @IBOutlet var bottomCoverButton4: UIButton!
    @IBOutlet var bottomCoverButton5: UIButton!
    
    var stackViewArray : [UIStackView]!
    private lazy var labels = [label1,label2,label3,label4,label5]
    private lazy var btns = [button1,button2,button3,button4,button5]
    var vcDelegate : MainBottomTapBarTapDelegate!
    static let MainBottomViewHeight:CGFloat = 50
    class func instanceFromNib(withDelegate delegate : ViewController) -> MainBottomView
    {
        let mainBottomView = UINib(nibName: "MainBottomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainBottomView
        mainBottomView.vcDelegate = delegate
        mainBottomView.frame.size = CGSize(width: Views.screenWidth, height: MainBottomView.MainBottomViewHeight + Views.bottomOffset )
//        mainBottomView.prepareStackView()
        return mainBottomView
    }
    
//    func prepareStackView()
//    {
//        stackViewArray = [bottomStackView1,bottomStackView2,bottomStackView3,bottomStackView4,bottomStackView5]
//        stackViewArray.forEach { (theStackView) in
//            let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
//            
//            theStackView.addGestureRecognizer(tap)
//        }
//    }
//    @objc func stackViewTapped(_ sender : UITapGestureRecognizer)
//    {
//        let view = sender.view
//        vcDelegate.userTapBottomTapBar(at: view!.tag)
//    }
    @IBAction func coverButtonDidTaped(_ sender : UIButton)
    {
        labels.forEach({$0?.textColor = .black})
        labels[sender.tag - 1]?.textColor = Themes.tabbarSelectedBlue
        btns.forEach({$0?.imageView?.templateImageView(with: .black)})
        btns[sender.tag - 1]?.imageView?.templateImageView(with: Themes.tabbarSelectedBlue)
        vcDelegate.userTapBottomTapBar(at: sender)
    }
    func setSelectedState(index:Int){
        DispatchQueue.main.async {
            self.labels.forEach({$0?.textColor = .black})
            self.labels[index]?.textColor = Themes.tabbarSelectedBlue
            self.btns.forEach({$0?.imageView?.templateImageView(with: .black)})
            self.btns[index]?.imageView?.templateImageView(with: Themes.tabbarSelectedBlue)
        }
    }
    
    @IBAction func buttonDidTaped(_ sender : UIButton)
    {
//        vcDelegate.userTapBottomTapBar(at: sender.tag)
    }
    func switchBottomLabelName(with isLogin : Bool)
    {
        self.button1.contentMode = .scaleAspectFit
        self.button2.contentMode = .scaleAspectFit
        self.button3.contentMode = .scaleAspectFit
        self.button4.contentMode = .scaleAspectFit
        self.button5.contentMode = .scaleAspectFit
        
        if isLogin == true
        {
            let afterBottomObject = HG_BottomAfterLogin()
            self.label1.text = afterBottomObject.label1
            self.label2.text = afterBottomObject.label2
            self.label3.text = afterBottomObject.label3
            self.label4.text = afterBottomObject.label4
            self.label5.text = afterBottomObject.label5
            
            self.button1.setImage(UIImage(named: "icon-18-tiger"), for: .normal)
            self.button2.setImage(UIImage(named: "icon-fire"), for: .normal)
            self.button3.setImage(UIImage(named: "icon-pocket"), for: .normal)
            self.button4.setImage(UIImage(named: "icon-ticket-money"), for: .normal)
            self.button5.setImage(UIImage(named: "icon-user"), for: .normal)
            
        }else
        {
            let beforeBottomObject = HG_BottomBeforeLogin()
            self.label1.text = beforeBottomObject.label1
            self.label2.text = beforeBottomObject.label2
            self.label3.text = beforeBottomObject.label3
            self.label4.text = beforeBottomObject.label4
            self.label5.text = beforeBottomObject.label5
            
            self.button1.setImage(UIImage(named: "icon-18-tiger"), for: .normal)
            self.button2.setImage(UIImage(named: "icon-fire"), for: .normal)
            self.button3.setImage(UIImage(named: "icon-crown"), for: .normal)
            self.button4.setImage(UIImage(named: "icon-group"), for: .normal)
            self.button5.setImage(UIImage(named: "icon-user"), for: .normal)
            
            
        }
        DispatchQueue.main.async {
            self.labels.first??.textColor = Themes.tabbarSelectedBlue
            self.btns.first??.imageView?.templateImageView(with: Themes.tabbarSelectedBlue)
        }
    }
     /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
