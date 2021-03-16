//
//  ForgatPasswordTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/22.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class ForgatPasswordTableViewCell: UITableViewCell,UITextFieldDelegate
{
    var hostView : ViewController!
    var step1SenderData : HG_PasswordSender!
    var step2SenderData : HG_PasswordSender!
    var step3SenderData : HG_PasswordSender!
    
    // Mark: 上層的 Slider
    @IBOutlet var fakeSliderView :UIView!
    @IBOutlet var infoVarifyDiscriptionLabel : UILabel!
    @IBOutlet var idVarifyDiscriptionLabel : UILabel!
    @IBOutlet var resetDiscriptionLabel : UILabel!
    @IBOutlet var label1 : UILabel!
    @IBOutlet var label2 : UILabel!
    @IBOutlet var label3 : UILabel!
    
    
    // 下層
    private var _stepValue : ForgatPasswordStep?
    var stepValue: ForgatPasswordStep? {
        get {
            return _stepValue
        }
        set {
            _stepValue = newValue
            resetAllStatus(with: _stepValue!)
        }
    }
    @IBOutlet var spaceView1 : UIView!
    @IBOutlet var spaceView1Plus : UIView!
    @IBOutlet var spaceView2 : UIView!
    @IBOutlet var spaceView3 : UIView!
    @IBOutlet var spaceView4 : UIView!
    // 步驟一 顯示元件 step1
    // 1.文字輸入以及顯示 提示 label
    @IBOutlet var insertInfoDescriptionLabel : UILabel!
    // 2.使用者 key in 手機或者郵箱 textfield
    @IBOutlet var userKeyInInfoTextfield: UITextField!
    // 3.使用者 key in 錯誤提示訊息 label
    @IBOutlet var userKeyInInfoErrorLabel: UILabel!
    // 4.使用者 確認按鈕
    @IBOutlet var userConfirmButton : UIButton!
    
    // 步驟二 顯示元件 setp2
    // 1.欲發送之驗證碼至電子郵箱或者手機Label
    @IBOutlet var showUserKeyinInfoDescriptionLabel : UILabel!
    @IBOutlet var showUserKeyinInfoLabel : UILabel!
    // 2.使用者 key in 驗證碼 textfield 由 step1 的 userKeyInInfoTextfield 取代
    // 3.使用者 key in 驗證碼提示訊息 label 由 step1 的 userKeyInInfoErrorLabel 取代
    // 4.使用者 確認按鈕 button 由 step1 的 userConfirmButton 取代
    
    // 步驟三 顯示元件 step3
    // 1.文字輸入以及顯示 label 提示 由 step1 的 insertInfoDescriptionLabel 取代
    // 2.使用者 key in 新密碼 textfield 由 step1 的 userKeyInInfoTextfield 取代
    // 3.使用者 key in 新密碼提示訊息 label 由 step1 的 userKeyInInfoErrorLabel 取代
    // 4.使用者 key in 再次輸入新密碼 textfield
    @IBOutlet var newPasswordConfirmTextfield : UITextField!
    // 5.使用者 key in 新書入新密碼提示訊息 label
    @IBOutlet var newPasswordConfirmErrorLabel : UILabel!
    // 6.使用者 點選 confirm button 後的訊息提示
    @IBOutlet var confirmButtonErrorLabel : UILabel!
    // 7.使用者 確認按鈕 button 由 step1 的 userConfirmButton 取代
    
    // 步驟四 顯示元件 step4
    // 1.修改成功打勾圖
    @IBOutlet var changePWSuccessImageview : UIImageView!
    // 2.成功文字顯示 label 提示 由 step1 的 insertInfoDescriptionLabel 取代
    // 3.回首頁 button 由 step1 的 userConfirmButton 取代
    
    @IBOutlet var gradientLayerView : UIView!
    var gradientLayer = CAGradientLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextfieldDelegateAndTarget()
        
    }
    func resetAllStatus(with flag: ForgatPasswordStep)
    {
        changeValueForSliderStatus(status: stepValue!)
        changeValueForInputUI(status: stepValue!)
        changeValueForInputStatus(status: stepValue!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupTextfieldDelegateAndTarget()
    {
        userKeyInInfoTextfield.delegate = self
        newPasswordConfirmTextfield.delegate = self
        userKeyInInfoTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newPasswordConfirmTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func changeValueForSliderStatus(status flag : ForgatPasswordStep)
    {
        setupLayerView()
        changeValueOfSliderGradientLayer(withFlag: flag)
        changeValueOfSliderLabels(withFlag: flag)
    }
    func setupLayerView()
    {
        var gRect = gradientLayerView.frame
        gRect.size.width = UIScreen.main.bounds.size.width-140
        gradientLayerView.frame = gRect
        //        gradientLayerView.frame = CGRect(x: 0, y: 0, width: label3.frame.minX, height: 2)
        gradientLayer.frame = gradientLayerView.bounds
        gradientLayer.colors = [Themes.lineBlueColor.cgColor,
                                UIColor.lightGray.cgColor,
                                UIColor.lightGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [0,0.35, 1] as [NSNumber]
        gradientLayerView.layer.addSublayer(gradientLayer)
    }
    func changeValueOfSliderLabels(withFlag flag : ForgatPasswordStep)
    {
        switch flag
        {
        case .Step1:
            idVarifyDiscriptionLabel.textColor = UIColor.black
            resetDiscriptionLabel.textColor = UIColor.lightGray
            label2.backgroundColor = UIColor.lightGray
            label2.textColor = UIColor.white
            label3.backgroundColor = UIColor.white
            label3.textColor = UIColor.lightGray
            label3.layer.borderColor = UIColor.lightGray.cgColor
            label3.layer.borderWidth = 2
            fakeSliderView.isHidden = false
        case .Step2:
            idVarifyDiscriptionLabel.textColor = Themes.lineBlueColor
            resetDiscriptionLabel.textColor = UIColor.black
            label2.backgroundColor = Themes.lineBlueColor
            label2.textColor = UIColor.white
            label3.backgroundColor = UIColor.lightGray
            label3.textColor = UIColor.white
            label3.layer.borderColor = UIColor.lightGray.cgColor
            label3.layer.borderWidth = 2
            fakeSliderView.isHidden = false
        case .Step3:
            idVarifyDiscriptionLabel.textColor = Themes.lineBlueColor
            resetDiscriptionLabel.textColor = Themes.lineBlueColor
            label2.backgroundColor = Themes.lineBlueColor
            label2.textColor = UIColor.white
            label3.backgroundColor = Themes.lineBlueColor
            label3.textColor = UIColor.white
            label3.layer.borderColor = Themes.lineBlueColor.cgColor
            label3.layer.borderWidth = 2
            fakeSliderView.isHidden = false
        case .Step4:
            print("完成")
            fakeSliderView.isHidden = true
        default:
            break
        }
    }
    func changeValueOfSliderGradientLayer(withFlag part : ForgatPasswordStep)
    {
        switch part
        {
        case .Step1:
            gradientLayer.colors = [Themes.lineBlueColor.cgColor,
                                    UIColor.lightGray.cgColor,
                                    UIColor.lightGray.cgColor]
            gradientLayer.locations = [0,0.35, 1] as [NSNumber]
        case .Step2:
            gradientLayer.colors = [Themes.lineBlueColor.cgColor,
                                    Themes.lineBlueColor.cgColor,
                                    UIColor.lightGray.cgColor,
                                    UIColor.lightGray.cgColor]
            gradientLayer.locations = [0,0.35,0.9 ,1] as [NSNumber]
        case .Step3:
            gradientLayer.colors = [Themes.lineBlueColor.cgColor,
                                    Themes.lineBlueColor.cgColor]
            gradientLayer.locations = [0, 1] as [NSNumber]
        case .Step4:
            print("完成")
            
        default:
            break
        }
        
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
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if CheckTextfieldCharacter(with: textField)
        {
            print("[ForgatPW] - Field Pass verify")
        }else
        {
            print("[ForgatPW] - False No Pass")
        }
        
    }
    func changeValueForInputUI(status flag : ForgatPasswordStep)
    {
        switch flag
        {
        case .Step1:
            spaceView1.isHidden = false
            spaceView1Plus.isHidden = !spaceView1.isHidden
            spaceView2.isHidden = true
            insertInfoDescriptionLabel.isHidden = false
            userKeyInInfoTextfield.isHidden = false
            userKeyInInfoErrorLabel.isHidden = true
            spaceView3.isHidden = true
            spaceView4.isHidden = false
            showUserKeyinInfoDescriptionLabel.isHidden = true
            showUserKeyinInfoLabel.isHidden = true
            newPasswordConfirmTextfield.isHidden = true
            newPasswordConfirmErrorLabel.isHidden = true
            confirmButtonErrorLabel.isHidden = true
            changePWSuccessImageview.isHidden = true
            
        case .Step2:
            spaceView1.isHidden = false
            spaceView1Plus.isHidden = !spaceView1.isHidden
            spaceView2.isHidden = true
            insertInfoDescriptionLabel.isHidden = true
            userKeyInInfoTextfield.isHidden = false
            userKeyInInfoErrorLabel.isHidden = true
            spaceView3.isHidden = true
            spaceView4.isHidden = false
            showUserKeyinInfoDescriptionLabel.isHidden = false
            showUserKeyinInfoLabel.isHidden = false
            newPasswordConfirmTextfield.isHidden = true
            newPasswordConfirmErrorLabel.isHidden = true
            confirmButtonErrorLabel.isHidden = true
            changePWSuccessImageview.isHidden = true
            
        case .Step3:
            spaceView1.isHidden = false
            spaceView1Plus.isHidden = !spaceView1.isHidden
            spaceView2.isHidden = true
            insertInfoDescriptionLabel.isHidden = false
            userKeyInInfoTextfield.isHidden = false
            userKeyInInfoErrorLabel.isHidden = true
            spaceView3.isHidden = false
            spaceView4.isHidden = false
            showUserKeyinInfoDescriptionLabel.isHidden = true
            showUserKeyinInfoLabel.isHidden = true
            newPasswordConfirmTextfield.isHidden = false
            newPasswordConfirmErrorLabel.isHidden = true
            confirmButtonErrorLabel.isHidden = true
            changePWSuccessImageview.isHidden = true
        case .Step4:
            spaceView1.isHidden = true
            spaceView1Plus.isHidden = !spaceView1.isHidden
            spaceView2.isHidden = false
            insertInfoDescriptionLabel.isHidden = true
            userKeyInInfoTextfield.isHidden = true
            userKeyInInfoErrorLabel.isHidden = true
            spaceView3.isHidden = true
            spaceView4.isHidden = true
            showUserKeyinInfoDescriptionLabel.isHidden = true
            showUserKeyinInfoLabel.isHidden = true
            newPasswordConfirmTextfield.isHidden = true
            newPasswordConfirmErrorLabel.isHidden = true
            confirmButtonErrorLabel.isHidden = true
            changePWSuccessImageview.isHidden = false
        default:
            break
        }
    }
    func changeValueForInputStatus(status flag : ForgatPasswordStep)
    {
        switch flag
        {
        case .Step1:
            insertInfoDescriptionLabel.text = Constants.Tiger_ForgatPW_Cell_Setp1_InsertInfoDescription
            userKeyInInfoTextfield.isSecureTextEntry = false
            userKeyInInfoTextfield.text = ""
            userKeyInInfoTextfield.placeholder = Constants.Tiger_ForgatPW_Cell_Setp1_FieldPlaceholderPhoneOrEmail
            userConfirmButton.setTitle(Constants.Tiger_ForgatPW_Cell_Setp1_NextStep, for: .normal)
        case .Step2:
            insertInfoDescriptionLabel.text = ""
            showUserKeyinInfoDescriptionLabel.text = Constants.Tiger_ForgatPW_Cell_Setp2_ShowUserKeyinInfo + step1SenderData.infoTypeDescription
            userKeyInInfoTextfield.isSecureTextEntry = false
            userKeyInInfoTextfield.text = ""
            userKeyInInfoTextfield.placeholder = Constants.Tiger_ForgatPW_Cell_Setp2_ShowVerifyString
            userConfirmButton.setTitle(Constants.Tiger_ForgatPW_Cell_Setp1_NextStep, for: .normal)
        case .Step3:
            insertInfoDescriptionLabel.text = Constants.Tiger_ForgatPW_Cell_Setp3_SetupNewPW
            userKeyInInfoTextfield.isSecureTextEntry = true
            userKeyInInfoTextfield.text = ""
            userKeyInInfoTextfield.placeholder = Constants.Tiger_ForgatPW_Cell_Setp3_FieldPlaceholderNewPW
            newPasswordConfirmTextfield.text = ""
            newPasswordConfirmTextfield.placeholder = Constants.Tiger_ForgatPW_Cell_Setp3_ConfirmFieldPlaceholderNewPW
            userConfirmButton.setTitle(Constants.Tiger_ForgatPW_Cell_Setp3_Supmit, for: .normal)
        case .Step4:
            insertInfoDescriptionLabel.isHidden = false
            insertInfoDescriptionLabel.text = Constants.Tiger_ForgatPW_Cell_Setp4_SuccessChangePW
            userConfirmButton.setTitle(Constants.Tiger_ForgatPW_Cell_Setp4_BackToMain, for: .normal)
        default :
            break
        }
    }
    // MARK: 正則表達式確認
    func CheckTextfieldCharacter(with textField: UITextField) -> Bool
    {
        confirmButtonErrorLabel.text = ""
        confirmButtonErrorLabel.isHidden = true
        if userKeyInInfoTextfield == textField
        {
            if (textField.text?.count)! == 0
            {
                print("沒有字元")
                if ForgatPasswordStep.Step1 == stepValue
                {
                    userKeyInInfoErrorLabel.isHidden = false
                    userKeyInInfoErrorLabel.text = Constants.Tiger_ForgatPW_Cell_ErrorUserEmailNoCurrect
                    userKeyInInfoTextfield.textColor = UIColor.red
                    confirmButtonErrorLabel.isHidden = true
                }
                else if ForgatPasswordStep.Step2 == stepValue
                {
                    userKeyInInfoErrorLabel.isHidden = true
                    confirmButtonErrorLabel.isHidden = false
                    confirmButtonErrorLabel.text = Constants.Tiger_ForgatPW_Cell_Step2_ErrorParameters
                }
                else if ForgatPasswordStep.Step3 == stepValue
                {
                    userKeyInInfoErrorLabel.isHidden = false
                    userKeyInInfoErrorLabel.text = Constants.Tiger_ForgatPW_Cell_Stet3_NewPWEmptyChat
                    confirmButtonErrorLabel.isHidden = true
                }
                else
                {
                    
                }
                return false
            }else
            {
                if ForgatPasswordStep.Step1 == stepValue
                {
                    let mailPattern =
                    "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
                    
                    var matcher: RegexHelperOld!
                    do {
                        matcher = try RegexHelperOld(mailPattern)
                    }catch
                    {
                        print(error)
                    }
                    if matcher.match(input: userKeyInInfoTextfield.text!)
                    {
                        print("有效的邮箱地址")
                        userKeyInInfoErrorLabel.isHidden = true
                        userKeyInInfoErrorLabel.text = ""
                        userKeyInInfoTextfield.textColor = UIColor.black
                        return true
                    }else
                    {
                        print("無效的邮箱地址")
                        userKeyInInfoErrorLabel.isHidden = false
                        userKeyInInfoErrorLabel.text = Constants.Tiger_ForgatPW_Cell_ErrorUserEmailNoCurrect
                        userKeyInInfoTextfield.textColor = UIColor.red
                        return false
                    }
                }else if ForgatPasswordStep.Step2 == stepValue
                {
                    return true
                }
                else if ForgatPasswordStep.Step3 == stepValue
                {
                    let passwordPattern = "[0-9a-zA-Z_]{8,20}"
                    var matcher: RegexHelperOld!
                    do {
                        matcher = try RegexHelperOld(passwordPattern)
                    }catch
                    {
                        print(error)
                    }
                    if matcher.match(input: userKeyInInfoTextfield.text!)
                    {
                        print("有效的密碼")
                        userKeyInInfoErrorLabel.isHidden = true
                        userKeyInInfoErrorLabel.text = ""
                        userKeyInInfoTextfield.textColor = UIColor.black
                        return true
                    }else
                    {
                        print("無效的密碼")
                        userKeyInInfoErrorLabel.isHidden = false
                        userKeyInInfoErrorLabel.text = Constants.Tiger_ForgatPW_Cell_Stet3_NewPWEmptyChat
                        userKeyInInfoTextfield.textColor = UIColor.red
                        return false
                    }
                }else
                {
                    
                }
               return false
            }
        }else if newPasswordConfirmTextfield == textField
        {
            if stepValue == ForgatPasswordStep.Step3
            {
                if (newPasswordConfirmTextfield.text == userKeyInInfoTextfield.text) &&
                    ((newPasswordConfirmTextfield.text?.count)! > 0)
                {
                    print("有效的確認密碼")
                    newPasswordConfirmErrorLabel.isHidden = true
                    newPasswordConfirmErrorLabel.text = ""
                    newPasswordConfirmTextfield.textColor = UIColor.black
                    return true
                }else
                {
                    print("無效的確認密碼")
                    newPasswordConfirmErrorLabel.isHidden = false
                    if newPasswordConfirmTextfield.text!.count >= userKeyInInfoTextfield.text!.count
                    {
                         newPasswordConfirmErrorLabel.text = Constants.Tiger_ForgatPW_Cell_Stet3_PWNoCurrect
                    }else
                    {
                         newPasswordConfirmErrorLabel.text = Constants.Tiger_ForgatPW_Cell_ErrorUserRecheckPWNoCurrect
                    }
                    newPasswordConfirmTextfield.textColor = UIColor.red
                    return false
                }
            }else
            {
                return false
            }
        }else
        {
                return false
        }
    }
    // MARK: -----
    // MARK: 確認發送
    @IBAction func confirmToServer(_ sender : UIButton)
    {
        if ForgatPasswordStep.Step1 == stepValue
        {
            if ( userKeyInInfoErrorLabel.isHidden == true &&
                confirmButtonErrorLabel.isHidden == true )
            {
                if CheckTextfieldCharacter(with: userKeyInInfoTextfield) == true
                {
                    print("可以傳送")
                    step1SenderData = HG_PasswordSender(VertifyInfo: userKeyInInfoTextfield.text!, Code: "", Password: "")

                    allCheckWellAndFire()
                }else
                {
                    print("不可以傳送")
                }
            }else
            {
                confirmButtonErrorLabel.isHidden = false
                confirmButtonErrorLabel.text = Constants.Tiger_ForgatPW_Cell_InsertError
            }
        }
        if ForgatPasswordStep.Step2 == stepValue
        {
            if ( userKeyInInfoErrorLabel.isHidden == true &&
                confirmButtonErrorLabel.isHidden == true )
            {
                if CheckTextfieldCharacter(with: userKeyInInfoTextfield) == true
                {
                    print("可以傳送")
                    step2SenderData = HG_PasswordSender(VertifyInfo: step1SenderData.VertifyInfo, Code: userKeyInInfoTextfield.text!, Password: "")
                    step2SenderData.infoType = step1SenderData.infoType
                    allCheckWellAndFire()
                }else
                {
                    print("不可以傳送")
                }
            }else
            {
                confirmButtonErrorLabel.isHidden = false
                confirmButtonErrorLabel.text = Constants.Tiger_ForgatPW_Cell_InsertError
            }
        }
        if ForgatPasswordStep.Step3 == stepValue
        {
            if ( userKeyInInfoErrorLabel.isHidden == true &&
                confirmButtonErrorLabel.isHidden == true )
            {
                if (CheckTextfieldCharacter(with: userKeyInInfoTextfield) == true) &&
                    (CheckTextfieldCharacter(with: newPasswordConfirmTextfield) == true)
                {
                    print("可以傳送")
                    step3SenderData = HG_PasswordSender(VertifyInfo: step1SenderData.VertifyInfo, Code: "", Password: newPasswordConfirmTextfield.text!)
                    allCheckWellAndFire()
                }else
                {
                    print("不可以傳送")
                }
            }else
            {
                confirmButtonErrorLabel.isHidden = false
                confirmButtonErrorLabel.text = Constants.Tiger_ForgatPW_Cell_InsertError
            }
        }
        if ForgatPasswordStep.Step4 == stepValue
        {
            hostView.resetCustomNavigationContainerView()
        }
    }
    func allCheckWellAndFire()
    {
        print("檢查完畢 與server 連線")
        let successClo : HG_SuccessClosures = { hgService in
            self.verifyWith(true, hgService as Any)

        }
        let failedClo : HG_FailedClosures = { errorData in
            self.verifyWith(false, errorData as Any)
            self.hostView.showErrorToast(with: errorData as Any)
        }
        let urlString :String!
        let bodyString :String!
        if ForgatPasswordStep.Step1 == stepValue
        {
            urlString = Constants.Tiger_MemberPasswordForgat
            bodyString = "VertifyInfo=\(step1SenderData.VertifyInfo)"
            
        }
        else if ForgatPasswordStep.Step2 == stepValue
        {
            urlString = (step1SenderData.infoType == 1) ? Constants.Tiger_MemberPasswordPhoneVertify : Constants.Tiger_MemberPasswordEmailVertify
            bodyString = "VertifyInfo=\(step2SenderData.VertifyInfo)&Code=\(step2SenderData.Code)"
        }
        else if ForgatPasswordStep.Step3 == stepValue
        {
            urlString = Constants.Tiger_MemberPasswordReset
            bodyString = "VertifyInfo=\(step3SenderData.VertifyInfo)&Password=\(step3SenderData.Password)"
        }else
        {
            urlString = ""
            bodyString = ""
        }
        
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: urlString, withPostString:bodyString , successComplete: successClo, failedException: failedClo)
    }
    func verifyWith(_ flag : Bool , _ message : Any)
    {
        if flag == true
        {
            OperationQueue.main.addOperation
                {
                    switch self.stepValue
                    {
                    case ForgatPasswordStep.Step1?:
                        self.step1SenderData.infoType = (message as! Int)
                        self.step1SenderData.infoTypeDescription = (self.step1SenderData.infoType == 1) ? Constants.Tiger_ForgatPW_Cell_Step2_FireToPhone: Constants.Tiger_ForgatPW_Cell_Step2_FireToMail
                        self.confirmButtonErrorLabel.isHidden = true
                        self.showUserKeyinInfoLabel.text = self.step1SenderData.VertifyInfo
                        self.stepValue = ForgatPasswordStep.Step2
                    case ForgatPasswordStep.Step2?:
                        self.step2SenderData.username = (message as! String)
                        self.stepValue = ForgatPasswordStep.Step3
                    case ForgatPasswordStep.Step3?:
                        self.stepValue = ForgatPasswordStep.Step4
                        print("成功更換密碼")
                    default :
                        break
                    }
            }
        }else
        {
            OperationQueue.main.addOperation
                {
                    switch self.stepValue
                    {
                    case ForgatPasswordStep.Step1?:
                        self.confirmButtonErrorLabel.isHidden = false
                        self.confirmButtonErrorLabel.text = String(message as! String)
                        
                    case ForgatPasswordStep.Step2?:
                        self.confirmButtonErrorLabel.isHidden = false
                        self.confirmButtonErrorLabel.text = String(message as! String)
                        
                    case ForgatPasswordStep.Step3?:
                        self.confirmButtonErrorLabel.isHidden = false
                        self.confirmButtonErrorLabel.text = String(message as! String)
                        
                    default :
                        break
                    }
                    
            }
        }
    }
}
