//
//  MainTopNavigationView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/23.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class MainTopNavigationView: UIView , Nibloadable
{
    @IBOutlet var tigerButton : UIButton!
    @IBOutlet var infoActionButton : UIButton!
    @IBOutlet var searchButton : UIButton!
    @IBOutlet var hotButton : UIButton!
    @IBOutlet var button3 : UIButton!
    @IBOutlet var button4 : UIButton!
    
    @IBOutlet var gradientLayerView : UIView!
    var vcDelegate : MainTopNavigationTapDelegate!
    class func instanceFromNib(withDelegate delegate : ViewController) -> MainTopNavigationView
    {
        let mainTopNavigationView = UINib(nibName: "MainTopNavigationView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainTopNavigationView
        mainTopNavigationView.vcDelegate = delegate
        mainTopNavigationView.setupLayerView()
        return mainTopNavigationView
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
        vcDelegate.userTapTopNavigation(at: sender)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
