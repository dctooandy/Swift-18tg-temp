//
//  CashOutView.swift
//  ProjectT
//
//  Created by AndyChen on 2019/3/18.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit
import SDWebImageSVGCoder

class CashOutView: UIView ,Nibloadable , UITextFieldDelegate
{
    var hostView : ViewController!
    @IBOutlet var bankAccountName : UILabel!
    @IBOutlet var inputMoneyTextfield : UITextField!
    @IBOutlet var selectedView : UIView!
    @IBOutlet var insertBankCardView : UIView!
    // 存款用銀行資料
    var forShowBankNameSelectionArray : [String] = []
    var forShowBankIconSelectionArray : [String] = []
    var forShowBankAccountSelectionArray : [String] = []
    var forNetTransBankCodeArray : [String] = []
    var forNetTransCurrentBankCodeString : String = ""
    var forNetTransBankSnArray : [String] = []
    var forNetTransCurrentBankSnString : String = ""
    
    @IBOutlet var currentBankLabel : UILabel!
    @IBOutlet var confirmButton : UIButton!
    @IBOutlet var bankImageView : UIImageView!
    // data source
    private var _userBankListAtInnerView : HG_GetUserBankListDto!
    var userBankListAtInnerView : HG_GetUserBankListDto!
    {
        get{
            return _userBankListAtInnerView
        }
        set{
            _userBankListAtInnerView = newValue
            setupSVGUI()
        }
    }
    private var _currentChannelMode : CashChannelMode!
    var currentChannelMode : CashChannelMode!
    {
        get{
            return _currentChannelMode
        }
        set{
            _currentChannelMode = newValue
//            changeUnderViewUIAction(_currentChannelMode)
        }
    }
    
    private var _cashierChannelAtInnerView : HG_CashierChannelDto!
    var cashierChannelAtInnerView : HG_CashierChannelDto!
    {
        get{
            return _cashierChannelAtInnerView
        }
        set{
            _cashierChannelAtInnerView = newValue
//            setupChannelBorder()
//            setupSVGUIAndModelView()
            
        }
    }
    var forShowBankChannel : HG_CashierChannelDataDto!
    
    private var _memberBankListAtInnerView : [HG_MemberBankList]!
    var memberBankListAtInnerView : [HG_MemberBankList]!
    {
        get{
            return _memberBankListAtInnerView
        }
        set{
            _memberBankListAtInnerView = newValue
            setupMemberInfo()
        }
    }
    
    override func awakeFromNib()
    {
        selectedView.layer.borderColor = UIColor.lightGray.cgColor
        selectedView.layer.borderWidth = 1
        insertBankCardView.layer.borderColor = UIColor.lightGray.cgColor
        insertBankCardView.layer.borderWidth = 1
    }
    
    
    func setupMemberInfo()
    {
        bankAccountName.text = memberBankListAtInnerView.first?.AccountName
        forNetTransBankSnArray.removeAll()
        if memberBankListAtInnerView.count > 0
        {
            for memberBankData in memberBankListAtInnerView
            {
                forNetTransBankSnArray.append(memberBankData.Sn)
            }
//            forNetTransBankSnArray.append((memberBankListAtInnerView.first?.Sn)!)
            forNetTransCurrentBankSnString = forNetTransBankSnArray[0]
        }
    }

    func setupSVGUI()
    {
        forShowBankAccountSelectionArray.removeAll()
        forShowBankNameSelectionArray.removeAll()
        forShowBankIconSelectionArray.removeAll()
        forNetTransBankCodeArray.removeAll()
        let userBankdict = userBankListAtInnerView?.data
        if let array = memberBankListAtInnerView
        {
            for innerDict in array
            {
                forShowBankNameSelectionArray.append(userBankdict![innerDict.AccountBank]!.BankName)
                forShowBankIconSelectionArray.append(userBankdict![innerDict.AccountBank]!.BankIcon)
                forShowBankAccountSelectionArray.append(innerDict.AccountNo)
//                forNetTransBankCodeArray.append(innerDict.key)
            }
            
            currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] + forShowBankAccountSelectionArray[0] : ""
            
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            let SVGImageSize = CGSize(width: 30, height: 30)
            bankImageView.sd_setImage(with: URL(string: (forShowBankIconSelectionArray.count > 0 ? forShowBankIconSelectionArray[0] : "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
        }
//        if let dict = userBankListAtInnerView?.data
//        {
//            for innerDict in dict
//            {
//                forShowBankNameSelectionArray.append(innerDict.value.BankName)
//                forShowBankIconSelectionArray.append(innerDict.value.BankIcon)
//                forNetTransBankCodeArray.append(innerDict.key)
//            }
//            forNetTransCurrentBankCodeString = forNetTransBankCodeArray.count > 0 ? forNetTransBankCodeArray[0] : ""
//            currentBankLabel.text = forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[0] : ""
//            let SVGCoder = SDImageSVGCoder.shared
//            SDImageCodersManager.shared.addCoder(SVGCoder)
//            let SVGImageSize = CGSize(width: 30, height: 30)
//            bankImageView.sd_setImage(with: URL(string: (forShowBankIconSelectionArray.count > 0 ? forShowBankIconSelectionArray[0] : "")), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
//        }

    }
    // TextField Delegate
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.endEditing(true)
    }
    func setupInputAction()
    {
        inputMoneyTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield : UITextField)
    {
//        let inputString = textfield.text! + ".00"
//        let minString = Double(forShowBankChannel.SingleMin!)!
//        let maxString = Double(forShowBankChannel.SingleMax!)!
//        
//        if inputString.count == 0
//        {
//            print("字數空白")
//            checkAmount = false
//        }else if let d = Double (inputString), d >= minString ,  d <= maxString
//        {
//            print("可打錢")
//            checkAmount = true
//        } else {
//            print("數目小於最低,或高於最高")
//            checkAmount = false
//        }
    }
    @IBAction func selectBankAction(_ sender : UIButton)
    {
        if forShowBankNameSelectionArray.count > 0
        {
            setupActionsheet()            
        }
    }
    func setupActionsheet()
    {
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertSheet.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        alertSheet.popoverPresentationController?.sourceView = self
        alertSheet.popoverPresentationController?.sourceRect = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 0, height: 0)
        alertSheet.addAction(cancelAction)
        
        for i in 0...forShowBankNameSelectionArray.count-1
        {
            var archiveAction : UIAlertAction!
            
            archiveAction = UIAlertAction(title: forShowBankNameSelectionArray.count > 0 ? forShowBankNameSelectionArray[i] + forShowBankAccountSelectionArray[i] : "", style: UIAlertAction.Style.default, handler:
                {
                    action in

//                    self.forNetTransCurrentBankCodeString = self.forNetTransBankCodeArray[i]
                    self.currentBankLabel.text = self.forShowBankNameSelectionArray.count > 0 ? self.forShowBankNameSelectionArray[i] + self.forShowBankAccountSelectionArray[i] : ""
//                    self.currentBankLabel.text = self.forShowBankNameSelectionArray[i]
                    self.forNetTransCurrentBankSnString = self.forNetTransBankSnArray[i]
                    let SVGCoder = SDImageSVGCoder.shared
                    SDImageCodersManager.shared.addCoder(SVGCoder)
                    let SVGImageSize = CGSize(width: 30, height: 30)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1), execute: {
                        self.bankImageView.sd_setImage(with: URL(string: self.forShowBankIconSelectionArray[i]), placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
                    })
                    
            })
            alertSheet.addAction(archiveAction)
        }
        hostView.present(alertSheet, animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender : UIButton)
    {
        let amountString = inputMoneyTextfield.text
        if (amountString?.count)! < 1
        {
            hostView.showToast(message: "请输入金额")
        }else
        {
            hostView.getPaymentPayoutOrder(Amount: amountString!, UserBankSn: forNetTransCurrentBankSnString)
        }
    }
    
    //添加銀行卡功能
    @IBAction func addBankCardAction(_ sender : UIButton)
    {
        hostView.mainViewDirectToAddBankCard()
    }
}
