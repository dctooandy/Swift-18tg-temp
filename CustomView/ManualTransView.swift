//
//  ManualTransView.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/15.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class ManualTransView: UIView , Nibloadable , UITextFieldDelegate
{
	@IBOutlet var targetGroupImageView: UIImageView!
	@IBOutlet weak var targetGroupNameLabel: UILabel!
	@IBOutlet weak var targetGroupAccountLabel: UILabel!
	@IBOutlet weak var transToCenterButton: UIButton!
	@IBOutlet weak var transToGroupButton: UIButton!
	@IBOutlet weak var centerAccountLabel: UILabel!
	@IBOutlet weak var inputTextField: UITextField!
	@IBOutlet weak var errorMessageLabel: UILabel!
	@IBOutlet weak var confirmButton: UIButton!
    var gameWalletArray : Array<String> = []
    var currentGroupInfo : HG_GamepoolData!
    var transFrom : String = "center"
    var transTo : String = ""
	override func awakeFromNib()
	{
		super.awakeFromNib()
        setupInputAndButtonUI()
        
	}
	var hostView : ViewController!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func animationForManualEditTextField()
    {
        let keyboardHeight = hostView.keyboardHeight
        let textFieldMaxY = inputTextField.frame.maxY
         if keyboardHeight < textFieldMaxY && keyboardHeight != 0{
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
                {
                    let startTransform = CGAffineTransform.init(translationX: 0, y: keyboardHeight - textFieldMaxY )
                    self.hostView.manualTransContainerView.transform = startTransform
            }, completion:nil)
        }
    }
    
    func animationForManualEndEditTextField() {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                self.hostView.manualTransContainerView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    func animationForManualTransView()
    {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                let startTransform = CGAffineTransform.init(translationX: 0, y: self.frame.size.height + self.hostView.view.frame.size.height + 100)
                self.hostView.manualTransContainerView.transform = startTransform
                
        }, completion:nil)
        
    }
    func insertForManualTransView(gameWalletInfo : Array<String> , currentGroup : HG_GamepoolData , image : UIImage)
    {
        gameWalletArray = gameWalletInfo
        currentGroupInfo = currentGroup
        let str = ((currentGroup.ColorCode == "null" ) ? "ffffffff" : (currentGroup.ColorCode == "empty" ) ? "ffffffff" : currentGroup.ColorCode)
        let index = str.index(str.startIndex, offsetBy: 1)
        let sub_Colorcode = Int(str[index...], radix: 16)
        self.targetGroupImageView.layer.cornerRadius = 30.0
        self.targetGroupImageView.layer.masksToBounds = true
        OperationQueue.main.addOperation {
            self.setupLabelUI()
            self.targetGroupImageView.image = image
            // Group 背景顏色
            self.targetGroupImageView.backgroundColor = UIColor(rgb: sub_Colorcode!, a: 1)
        }
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations:
            {
                
                self.hostView.manualTransContainerView.transform = CGAffineTransform.identity
        }, completion:nil)
    }
    @IBAction func dismissTransView(_ sender : UIButton)
    {
        self.endEditing(true)
       animationForManualTransView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animationForManualEditTextField()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animationForManualEndEditTextField()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return true
	}
	@IBAction func transButtonAction(_ sender: UIButton)
	{
		if sender.tag == 1
		{
			print("轉到 中心 錢包")
			transToCenterButton.backgroundColor = Themes.lightBlueLayer
            transToCenterButton.setTitleColor(UIColor.white, for: .normal)
            transToCenterButton.layer.borderColor = Themes.lightBlueLayer.cgColor
            transFrom = currentGroupInfo.GroupId
            transTo = "center"
            transToGroupButton.backgroundColor = UIColor.white
            transToGroupButton.setTitleColor(UIColor.black, for: .normal)
			transToGroupButton.layer.borderColor = UIColor.black.cgColor
		}else if sender.tag == 2
		{
			print("轉到 Group 錢包")
			transToCenterButton.backgroundColor = UIColor.white
            transToCenterButton.setTitleColor(UIColor.black, for: .normal)
            transToCenterButton.layer.borderColor = UIColor.black.cgColor
            transFrom = "center"
            transTo = currentGroupInfo.GroupId
            transToGroupButton.backgroundColor = Themes.lightBlueLayer
            transToGroupButton.setTitleColor(UIColor.white, for: .normal)
			transToGroupButton.layer.borderColor = Themes.lightBlueLayer.cgColor
		}else
		{
			print("不知道是哪個按鈕")
		}
	}
	@IBAction func confirmButtonAction(_ sender : UIButton)
	{
        self.endEditing(true)
		if inputTextField.text?.count == 0
		{
			errorMessageLabel.text = "转帐金额"
		}
		else
		{
			print("已輸入金額,進入判斷流程")
            if (inputTextField.text?.count)! > 0
            {
                animationForManualTransView()
                hostView.addBlurView()
                hostView.addAndStartSpiner()
                hostView.getWalletTransfer(UserId: hostView.userAdminMember!.detailDatas!.UserId, TransferCash: inputTextField.text!, TransFrom: transFrom, TransTo: transTo)
            }else
            {
                errorMessageLabel.isHidden = false
                errorMessageLabel.text = "转帐金额"
            }
		}
	}
	@objc func textFieldDidChange(_ textField: UITextField)
	{
		if textField.text?.count == 0
		{
			errorMessageLabel.isHidden = false
			errorMessageLabel.text = "转帐金额"
		}else
		{
			errorMessageLabel.isHidden = true
			errorMessageLabel.text = ""
		}
	}

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.endEditing(true)
    }
    func setupInputAndButtonUI()
    {
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        errorMessageLabel.isHidden = true
        transToCenterButton.layer.borderColor = Themes.lightBlueLayer.cgColor
        transToCenterButton.layer.borderWidth = 1
        transToGroupButton.layer.borderColor = UIColor.black.cgColor
        transToGroupButton.layer.borderWidth = 1
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    func setupLabelUI()
    {
        let theButton = UIButton(type: .custom)
        theButton.tag = 2
        transButtonAction(theButton)
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current
        
        let cashStr = (hostView.hgServiceUserWalletInfo.first)!.Cash
        let cashString = currencyFormatter.string(from: NSNumber(value: Float((cashStr))!))!
        let cashRange = cashString.index(after: cashString.startIndex)..<cashString.endIndex
        centerAccountLabel.text = String(cashString[cashRange])
        let gameWalletCashStr = gameWalletArray[1]
        let gameWalletCashString = currencyFormatter.string(from: NSNumber(value: Float((gameWalletCashStr))!))!
        let gameWalletCashRange = gameWalletCashString.index(after: gameWalletCashString.startIndex)..<gameWalletCashString.endIndex
        targetGroupAccountLabel.text = String(gameWalletCashString[gameWalletCashRange])
        transTo = currentGroupInfo.GroupId
        transFrom = "center"
        targetGroupNameLabel.text = currentGroupInfo.CompanyName + "钱包"
    }
}
