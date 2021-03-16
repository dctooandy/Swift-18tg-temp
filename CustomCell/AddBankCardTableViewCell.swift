//
//  AddBankCardTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class AddBankCardTableViewCell: UITableViewCell , UITextFieldDelegate
{
    var hostView : ViewController!
    var countryListData : HG_GetCountryDto!
    var userBankList : HG_GetUserBankListDto!
    private var _memberBankName : String!
    var memberBankName : String!
    {
        get{
            return _memberBankName
        }
        set{
            _memberBankName = newValue
            self.accountOwnerLabel.text = _memberBankName
        }
    }
    // 銀行別
    var forShowBankNameSelectionArray : [String] = []
    var forShowBankNameString : String = ""
    var forNetTransBankCodeArray : [String] = []
    var forNetTransBankCodeString : String = ""
    
    // 省份別
    var forShowProvinceNameSelectionArray : [String] = []
    var forShowProvinceNameString : String = ""
    var forNetTransProvinceCodeArray : [String] = []
    var forNetTransProvinceCodeString : String = ""
    // 城市別
    var forShowCityNameSelectionArray : [String] = []
    var forShowCityNameString : String = ""
    var forNetTransCityCodeArray : [String] = []
    var forNetTransCityCodeString : String = ""
    // 區域別
    var forShowStateNameSelectionArray : [String] = []
    var forShowStateNameString : String = ""
    var forNetTransStateCodeArray : [String] = []
    var forNetTransStateCodeString : String = ""
    
    @IBOutlet var accountOwnerLabel : UILabel!
    @IBOutlet var accountNumberTextField : UITextField!
    @IBOutlet var errorOfAccountNumberLabel : UILabel!
    
    @IBOutlet var bankSelectedView : UIView!
    @IBOutlet var bankForShowLabel : UILabel!
    @IBOutlet var errorOfBankSelectedLabel : UILabel!
    
    @IBOutlet var provinceSelectedView : UIView!
    @IBOutlet var provinceForShowLabel : UILabel!
    @IBOutlet var errorOfProvinceSelectedLabel : UILabel!
    
    @IBOutlet var citySelectedView : UIView!
    @IBOutlet var cityForShowLabel : UILabel!
    @IBOutlet var errorOfCitySelectedLabel : UILabel!
    
    @IBOutlet var areaSelectedView : UIView!
    @IBOutlet var areaForShowLabel : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setupViewForBorder()
        
        // Initialization code
    }
    func setupViewForBorder()
    {
        bankSelectedView.layer.borderColor = UIColor.lightGray.cgColor
        bankSelectedView.layer.borderWidth = 1
        provinceSelectedView.layer.borderColor = UIColor.lightGray.cgColor
        provinceSelectedView.layer.borderWidth = 1
        citySelectedView.layer.borderColor = UIColor.lightGray.cgColor
        citySelectedView.layer.borderWidth = 1
        areaSelectedView.layer.borderColor = UIColor.lightGray.cgColor
        areaSelectedView.layer.borderWidth = 1
        
        errorOfBankSelectedLabel.isHidden = true
        errorOfProvinceSelectedLabel.isHidden = true
        errorOfCitySelectedLabel.isHidden = true
        errorOfAccountNumberLabel.isHidden = true
        setupInputAction()
 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectedAction(_ sender : UIButton)
    {
        switch sender.tag
        {
        case 1:
            print("開戶行 點到了")
            setupBankListData()
            setupActionsheet(flag: .SelectBankOption, forShowLabel: bankForShowLabel)
        case 2:
            print("Provice 點到了")
            setupProvinceData()
            setupActionsheet(flag: .ProvinceOption, forShowLabel: provinceForShowLabel)
        case 3:
            print("City 點到了")
            if forNetTransProvinceCodeString != ""
            {
                setupCityData()
                setupActionsheet(flag: .CityOption, forShowLabel: cityForShowLabel)
            }else
            {
                hostView.showErrorToast(with: "请先选择省份")
            }
        case 4:
            print("Area 點到了")
            if forNetTransCityCodeString != ""
            {
                setupStateData()
                if forShowStateNameSelectionArray.count > 0
                {
                    setupActionsheet(flag: .StateOption, forShowLabel: areaForShowLabel)
                }
            }else
            {
                hostView.showErrorToast(with: "请先选择城市")
            }
        default:
            break
        }
    }
    func detectAllforNetTransString() -> Bool
    {
        var finnalCheck = false
        if (accountNumberTextField.text?.count)! > 0
        {
            errorOfAccountNumberLabel.isHidden = true
            if forNetTransBankCodeString != ""
            {
                //            finnalCheck = true
                errorOfBankSelectedLabel.isHidden = true
                if forNetTransProvinceCodeString != ""
                {
                    //                finnalCheck = true
                    errorOfProvinceSelectedLabel.isHidden = true
                    if forNetTransCityCodeString != ""
                    {
                        finnalCheck = true
                        errorOfCitySelectedLabel.isHidden = true
                    }else
                    {
                        finnalCheck = false
                        errorOfCitySelectedLabel.isHidden = false
                    }
                }else
                {
                    finnalCheck = false
                    errorOfProvinceSelectedLabel.isHidden = false
                }
            }else
            {
                finnalCheck = false
                errorOfBankSelectedLabel.isHidden = false
            }
        }else
        {
            finnalCheck = false
            errorOfAccountNumberLabel.isHidden = false
        }
        
        
        return finnalCheck
    }
    func setupBankListData()
    {
        if let dict = userBankList?.data
        {
            forShowBankNameSelectionArray.removeAll()
            forNetTransBankCodeArray.removeAll()
            
            for innerDict in dict
            {
                forShowBankNameSelectionArray.append(innerDict.value.BankName)
                forNetTransBankCodeArray.append(innerDict.key)
            }
        }
    }
    func setupProvinceData()
    {
        if let dict = countryListData?.province
        {
            forShowProvinceNameSelectionArray.removeAll()
            forNetTransProvinceCodeArray.removeAll()
            
            for innerDict in dict
            {
                forShowProvinceNameSelectionArray.append(innerDict.value)
                forNetTransProvinceCodeArray.append(innerDict.key)
            }
        }
    }
    func setupCityData()
    {
        if let dict = countryListData?.city
        {
            forShowCityNameSelectionArray.removeAll()
            forNetTransCityCodeArray.removeAll()
            
            for innerDict in dict[forNetTransProvinceCodeString]!
            {
                forShowCityNameSelectionArray.append(innerDict.value)
                forNetTransCityCodeArray.append(innerDict.key)
            }
        }
    }
    func setupStateData()
    {
        if let dict = countryListData?.area
        {
            forShowStateNameSelectionArray.removeAll()
            forNetTransStateCodeArray.removeAll()
            
            if let Dict = dict[forNetTransCityCodeString]
            {
                for innerDict in Dict
                {
                    forShowStateNameSelectionArray.append(innerDict.value)
                    forNetTransStateCodeArray.append(innerDict.key)
                }
            }
        }
    }
    
    func returnCurrentNameArray(_ flag : AddBankInfoMode) -> [String]
    {
        switch flag
        {
        case .SelectBankOption:
            return forShowBankNameSelectionArray
        case .ProvinceOption:
            return forShowProvinceNameSelectionArray
        case .CityOption:
            return forShowCityNameSelectionArray
        case .StateOption:
            return forShowStateNameSelectionArray
        default:
            return [""]
        }
    }
    func returnCurrentCodeArray(_ flag : AddBankInfoMode) -> [String]
    {
        switch flag
        {
        case .SelectBankOption:
            return forNetTransBankCodeArray
        case .ProvinceOption:
            return forNetTransProvinceCodeArray
        case .CityOption:
            return forNetTransCityCodeArray
        case .StateOption:
            return forNetTransStateCodeArray
        default:
            return [""]
        }
    }
    func setCurrentString(flag : AddBankInfoMode , currentString : String)
    {
        switch flag
        {
        case .SelectBankOption:
            forNetTransBankCodeString = currentString
        case .ProvinceOption:
            forNetTransProvinceCodeString = currentString
        case .CityOption:
            forNetTransCityCodeString = currentString
        case .StateOption:
            forNetTransStateCodeString = currentString
        default:
            break
        }
    }
    func setupActionsheet(flag : AddBankInfoMode ,  forShowLabel : UILabel)
    {
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertSheet.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        alertSheet.popoverPresentationController?.sourceView = self.contentView
        alertSheet.popoverPresentationController?.sourceRect = CGRect(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY, width: 0, height: 0)
        alertSheet.addAction(cancelAction)

        let currentNameArray = returnCurrentNameArray(flag)
        let currentCodeArray = returnCurrentCodeArray(flag)
        for i in 0...currentNameArray.count-1
        {
            var archiveAction : UIAlertAction!
            
            archiveAction = UIAlertAction(title: currentNameArray[i], style: UIAlertAction.Style.default, handler:
                {
                    action in
                    if flag == .ProvinceOption
                    {
                        self.forNetTransCityCodeString = ""
                        self.cityForShowLabel.text = self.errorOfCitySelectedLabel.text!
                        self.forNetTransStateCodeString = ""
                        self.areaForShowLabel.text = "区县"
                    }else if flag == .CityOption
                    {
                        self.forNetTransStateCodeString = ""
                        self.areaForShowLabel.text = "区县"
                    }else
                    {
                        
                    }
                    self.setCurrentString(flag: flag, currentString: currentCodeArray[i])
                    forShowLabel.text = currentNameArray[i]
                    if self.detectAllforNetTransString() == true
                    {
                        
                    }
            })
            alertSheet.addAction(archiveAction)
        }
        hostView.present(alertSheet, animated: true, completion: nil)
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
        accountNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield : UITextField)
    {
        if (textfield.text?.count)! < 1
        {
            errorOfAccountNumberLabel.isHidden = false
            errorOfAccountNumberLabel.text = "银行卡号"
        }else
        {
            errorOfAccountNumberLabel.isHidden = true
        }
    }
    @IBAction func confirmAction(_ sender : UIButton)
    {
        if detectAllforNetTransString() == true
        {
            hostView.addBlurView()
            hostView.addAndStartSpiner()
            hostView.getMemberBankManageAdd(
                AccountBank: forNetTransBankCodeString,
                AccountName: accountOwnerLabel.text!,
                AccountNo: accountNumberTextField.text!,
                Province: forNetTransProvinceCodeString,
                City: forNetTransCityCodeString,
                State: forNetTransStateCodeString)
        }else
        {
            print("還有選項沒有完成")
            hostView.showErrorToast(with: "还有选项没有完成")
//            hostView.mainTableView.reloadData()
        }
    }
    func clearAllData()
    {
        accountNumberTextField.text = ""
        bankForShowLabel.text = errorOfBankSelectedLabel.text
        provinceForShowLabel.text = errorOfProvinceSelectedLabel.text
        cityForShowLabel.text = errorOfCitySelectedLabel.text
    }
}
