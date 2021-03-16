//
//  SignLoginTableViewCell.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/2/15.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import UIKit

class SignLoginTableViewCell: UITableViewCell , UITextFieldDelegate
{
    @IBOutlet var referenceLabel:UILabel!
    @IBOutlet var privateRightLabel:UILabel!
    @IBOutlet var loginLabel : UILabel!
    @IBOutlet var signupLabel : UILabel!
    @IBOutlet var leftLineImageView : UIImageView!
    @IBOutlet var rightLineImageView : UIImageView!
    @IBOutlet var loginButton : UIButton!
    @IBOutlet var signupButton : UIButton!
    
    @IBOutlet var sliderBar : UISlider!
    @IBOutlet var greenSliderImageView : UIImageView!
    @IBOutlet var graySliderImageView : UIImageView!
    @IBOutlet var whiteLabel : UILabel!
    
    //登入註冊用區塊
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var userPhoneTextField : UITextField!
    @IBOutlet var userPasswordTextField : UITextField!
    @IBOutlet var userPWConfirmTextField : UITextField!
    
    @IBOutlet var userNameErrorLabel : UILabel!
    @IBOutlet var userPhoneErrorLabel : UILabel!
    @IBOutlet var userPasswordErrorLabel : UILabel!
    @IBOutlet var userReCheckPWErrorLabel : UILabel!
    
    @IBOutlet var emptySpaceLabel1 : UILabel!
    @IBOutlet var emptySpaceLabel2 : UILabel!
    @IBOutlet var emptySpaceLabel4 : UILabel!
    @IBOutlet var emptySpaceLabel5 : UILabel!
    // Error Label
    @IBOutlet var errorLabel : UILabel!
    // 確認Label
    @IBOutlet var confirmLabel : UILabel!
    // 確認按鈕
    @IBOutlet var confirmButton : UIButton!
    @IBOutlet var confirmStackView : UIStackView!
    // 底下 忘記密碼按鈕
    @IBOutlet var forgatPasswordButton : UIButton!
    // 底下 註冊按鈕
    @IBOutlet var bottomSignUpButton : UIButton!
    @IBOutlet var orLaberl : UILabel!
    
    @IBOutlet var alreadySignupDescriptionLabel : UILabel!
    @IBOutlet var directToLoginActionButton : UIButton!
    
    @IBOutlet var checkMarkUpStackView : UIStackView!
    @IBOutlet var checkMarkBottomStackView : UIStackView!
    @IBOutlet var checkMarkErrorLabel : UILabel!
    @IBOutlet var spaceLabel : UILabel!
    @IBOutlet var checkMarkButton : UIButton!
    
    var isLoginMode : Bool = true
    var labelStringXArray : Array<CGFloat> = []
    var labelStringRangeArray : Array<Any> = []
    var isTriggerSlider : Bool = false
    var resizeDoneImage : UIImage!
    var resizeReadyImage : UIImage!
    var loginData : HG_MemberLoginData!
    var signUpData : HG_MemberSignUpData!
    var selectTextField: UITextField!
    
    var vcDelegate : SignLoginTableViewCellDelegate!
    var checkMarkOn : Bool! = true
    
    var hostView : ViewController!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setDetectKeyboard()
        setupSlider()
        setupLabelArray()
        setupSliderImage()
        setupMainTextfieldShow(isLogin: isLoginMode)
        userNameTextField.delegate = self
        userPhoneTextField.delegate = self
        userPasswordTextField.delegate = self
        userPWConfirmTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userPhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userPWConfirmTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        checkMarkButton.layer.borderColor = UIColor.black.cgColor
        checkMarkButton.layer.borderWidth = 1
        
        let panGesture = UIPanGestureRecognizer(target: self, action:  #selector(panGesture(gesture:)))
        self.sliderBar.addGestureRecognizer(panGesture)
        // Initialization code
        setTapGesture()
    }
    func setTapGesture()
    {
        let referenceTaps = UITapGestureRecognizer(target: self, action: #selector(handleReferenceTapGesture))
        referenceLabel.addGestureRecognizer(referenceTaps)
        referenceLabel.isUserInteractionEnabled = true
        let privateRightTaps = UITapGestureRecognizer(target: self, action: #selector(handlePrivateRightTapGesture))
        privateRightLabel.addGestureRecognizer(privateRightTaps)
        privateRightLabel.isUserInteractionEnabled = true
    }
    @objc func handleReferenceTapGesture()
    {
        print("\(Constants.Tiger_ReferencePage)")
        if let url = URL(string: Constants.Tiger_ReferencePage)
        {
            if UIApplication.shared.canOpenURL(url)
            {
                hostView.mainViewDirectToReferencePage()
            }
            else
            {
                hostView.showToast(message: Constants.Tiger_ToastError_WebPageUrlError)
            }
        }
    }
    @objc func handlePrivateRightTapGesture()
    {
        print("\(Constants.Tiger_PrivateRightPage)")
        if let url = URL(string: Constants.Tiger_PrivateRightPage)
        {
            if UIApplication.shared.canOpenURL(url)
            {
                hostView.mainViewDirectToPrivateRightPage()
            }
            else
            {
                hostView.showToast(message: Constants.Tiger_ToastError_WebPageUrlError)
            }
        }
    }
    @objc func panGesture(gesture:UIPanGestureRecognizer){
        let currentPoint = gesture.location(in: sliderBar)
        let percentage = currentPoint.x/sliderBar.bounds.size.width;
        let delta = Float(percentage) *  (sliderBar.maximumValue - sliderBar.minimumValue)
        let value = sliderBar.minimumValue + delta
        sliderBar.setValue(value, animated: true)
        sliderValueChanged(sliderBar)
        if gesture.state == .ended || gesture.state == .cancelled{
            sliderTouchUpInside(sliderBar)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupSlider()
    {
        sliderBar.value = 0.0
        self.bringSubviewToFront(sliderBar)
    }
    func setupLabelArray()
    {
        let labelString :String = whiteLabel.text!
        
        for charA in Array(labelString)
        {
            let labelStringRect = whiteLabel.boundingRect(forCharacterRange: NSRange(labelString.range(of: String(charA))!, in: labelString))
            print("rect : \(String(describing: labelStringRect))")
            labelStringXArray.append((labelStringRect?.origin.x)!)
            labelStringRangeArray.append(NSRange(labelString.range(of: String(charA))!, in: labelString) as Any)
        }
    }
    func setupSliderImage()
    {
        let imageDoneSize = CGSize(width: 30.0, height: 30.0)
        let thumDoneImage = UIImage(named: "SliderDone")
        resizeDoneImage = (thumDoneImage?.reSizeImage(reSize: imageDoneSize))!
        
        let imageReadySize = CGSize(width: 30.0, height: 30.0)
        let thumReadyImage = UIImage(named: "SliderReady")
        resizeReadyImage = (thumReadyImage?.reSizeImage(reSize: imageReadySize))!
        sliderBar.setThumbImage(resizeReadyImage, for: .normal)
    }
    func setupMainTextfieldShow(isLogin loginFlag : Bool)
    {
        self.endEditing(true)
        if loginFlag == true
        {
            loginLabel.textColor = UIColor(red: 0, green: 39/255, blue: 118/255, alpha: 1.0)
            signupLabel.textColor = UIColor.black
            leftLineImageView.backgroundColor = UIColor(red: 0, green: 39/255, blue: 118/255, alpha: 1.0)
            rightLineImageView.backgroundColor = UIColor.lightGray
            userNameTextField.isHidden = false
            userPhoneTextField.isHidden = true
            userPasswordTextField.isHidden = false
            userPWConfirmTextField.isHidden = true
            emptySpaceLabel2.isHidden = true
            emptySpaceLabel5.isHidden = true
            isLoginMode = true
            errorLabel.isHidden = true
            checkMarkUpStackView.isHidden = true
            checkMarkBottomStackView.isHidden = true
            spaceLabel.isHidden = true
            checkMarkErrorLabel.isHidden = true
            forgatPasswordButton.isHidden = false
            orLaberl.isHidden = false
            alreadySignupDescriptionLabel.isHidden = true
            directToLoginActionButton.isHidden = true
            bottomSignUpButton.isHidden = false
        }else
        {
            loginLabel.textColor = UIColor.black
            signupLabel.textColor = UIColor(red: 0, green: 39/255, blue: 118/255, alpha: 1.0)
            leftLineImageView.backgroundColor = UIColor.lightGray
            rightLineImageView.backgroundColor = UIColor(red: 0, green: 39/255, blue: 118/255, alpha: 1.0)
            userNameTextField.isHidden = false
            userPhoneTextField.isHidden = false
            userPasswordTextField.isHidden = false
            userPWConfirmTextField.isHidden = false
            emptySpaceLabel2.isHidden = false
            emptySpaceLabel5.isHidden = false
            isLoginMode = false
            errorLabel.isHidden = true
            checkMarkUpStackView.isHidden = false
            checkMarkBottomStackView.isHidden = false
            spaceLabel.isHidden = false
            checkMarkErrorLabel.isHidden = true
            forgatPasswordButton.isHidden = true
            orLaberl.isHidden = true
            alreadySignupDescriptionLabel.isHidden = false
            directToLoginActionButton.isHidden = false
            bottomSignUpButton.isHidden = true
        }
        userNameTextField.text = ""
        userPhoneTextField.text = ""
        userPasswordTextField.text = ""
        userPWConfirmTextField.text = ""
        userNameErrorLabel.isHidden = true
        userPhoneErrorLabel.isHidden = true
        userPasswordErrorLabel.isHidden = true
        userReCheckPWErrorLabel.isHidden = true
        userNameErrorLabel.text = ""
        userPhoneErrorLabel.text = ""
        userPasswordErrorLabel.text = ""
        userReCheckPWErrorLabel.text = ""
        emptySpaceLabel1.isHidden = false
        emptySpaceLabel4.isHidden = false
        if isTriggerSlider == true
        {
            resetAllUI()
        }

    }
    @IBAction func sliderValueChanged(_ sender : UISlider)
    {
        greenSliderImageView.isHidden = false
        if isTriggerSlider == false
        {
            let widthValue = sender.value
            if sender.value == sender.maximumValue {
                sliderBar.gestureRecognizers?.forEach{ $0.isEnabled = false}
                sliderTouchUpInside(sender)
            }
            var greenRect = greenSliderImageView.frame
            var diff : CGFloat = 15.0
            if CGFloat(sender.value) <= (sender.bounds.size.width/2)
            {
                diff = (diff * (1 - CGFloat(sender.value/150)))
                
            }else
            {
                diff = (diff * (CGFloat(sender.value/150) - 1)) * 0.3
            }
            greenRect.size.width = (CGFloat(widthValue) + CGFloat(diff) )
// 字體顏色經過Slider 會變色
//            let attribute = NSMutableAttributedString.init(string: whiteLabel.text!)
//            for charX in labelStringXArray
//            {
//                let indexOfChat = labelStringXArray.firstIndex(of: charX)
//                if CGFloat(widthValue) > charX
//                {
//                    attribute.addAttribute(.foregroundColor, value: UIColor.white, range: labelStringRangeArray[indexOfChat!] as! NSRange)
//
//                }
//            }
//            whiteLabel.attributedText = attribute
            greenSliderImageView.frame = greenRect
            print("widthValue : \(widthValue), diff : \(diff)")
        }
    }
 
    @IBAction func sliderTouchUpInside(_ sender: UISlider)
    {
        if sender.value == sender.maximumValue
        {
            isTriggerSlider = true
            sliderBar.isUserInteractionEnabled = false
            whiteLabel.text = Constants.Tiger_Text_SliderDonePlaceHolder
            whiteLabel.textColor = UIColor.white
            graySliderImageView.backgroundColor = UIColor(red: 103/255, green: 204/255, blue: 102/255, alpha: 1.0)
            sliderBar.setThumbImage(resizeDoneImage, for: .normal)
            
            errorLabel.isHidden = true
            resetConfirmButtonRect()
        }else
        {
            sender.value = 0
            sliderValueChanged(sender)
        }
    }
    func resetAllUI()
    {
        isTriggerSlider = false
        sliderBar.isUserInteractionEnabled = true
        sliderBar.value = 0
        sliderBar.gestureRecognizers?.forEach{ $0.isEnabled = true }
        graySliderImageView.backgroundColor = UIColor.lightGray
        greenSliderImageView.backgroundColor = UIColor(red: 103/255, green: 204/255, blue: 102/255, alpha: 1.0)
        whiteLabel.text = Constants.Tiger_Text_SliderPlaceHolder
        whiteLabel.textColor = UIColor.black
        sliderValueChanged(sliderBar)
        sliderBar.setThumbImage(resizeReadyImage, for: .normal)
    }
    
    // MARK: Keyboard detect
    func resetConfirmButtonRect()
    {
        let confirmRect = confirmStackView.frame
        confirmButton.frame = confirmRect
    }
    
    func setDetectKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: Notification)
    {
        if selectTextField == nil { return }
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            if (self.hostView.customTableviewModeFlag == MainTableviewMode.SignupActionMode) ||
                (self.hostView.customTableviewModeFlag == MainTableviewMode.LoginActionMode)
            {
                hostView.mainTableView.scrollToKeyboardTop(keyboardHeight: keyboardFrame.cgRectValue.height)
            }
            selectTextField = nil                
        }
    }
    @objc func keyboardDidHide(_ notification: Notification)
    {
        if (self.hostView.customTableviewModeFlag == MainTableviewMode.SignupActionMode) ||
            (self.hostView.customTableviewModeFlag == MainTableviewMode.LoginActionMode)
        {
            hostView.mainTableView.scrollToKeyboardTop(keyboardHeight: 0)
        }
        selectTextField = nil
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("DidBeginEditing")
        selectTextField = textField
        if CheckTextfieldCharacter(with: textField)
        {
            print("DidBeginEditing checkFlag :")
        }
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("shouldChangeCharactersIn")
        if userPhoneTextField == textField
        {
            if (range.location == 11) && (string.count > 0)
            {
                return false
            }else
            {
                return true
            }
        }
        if (userNameTextField == textField)
        {
            if (range.location == 16) && (string.count > 0)
            {
                return false
            }else
            {
                return true
            }
        }
        if (userPasswordTextField == textField) ||
            (userPWConfirmTextField == textField)
        {
            if (range.location == 20) && (string.count > 0)
            {
                return false
            }else
            {
                return true
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("DidEndEditing")
        if CheckTextfieldCharacter(with: textField)
        {
            print("FieldDidEndEditing checkFlag :")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if CheckTextfieldCharacter(with: textField)
        {
                print("FieldDidChange checkFlag :")
        }
        if isLoginMode == true
        {
            let bottomObjectRect = forgatPasswordButton.frame
            var cellRect = self.frame
            
            cellRect.size.height = bottomObjectRect.maxY + 30
        }else
        {
            let bottomObjectRect = alreadySignupDescriptionLabel.frame
            var cellRect = self.frame
            
            cellRect.size.height = bottomObjectRect.maxY + 30
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.endEditing(true)
    }
    // MARK: 正則表達式確認
    func CheckTextfieldCharacter(with textField: UITextField) -> Bool
    {
        if userNameTextField == textField
        {
            if (textField.text?.count)! == 0
            {
                userNameErrorLabel.isHidden = false
                emptySpaceLabel1.isHidden = true
                userNameErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserNameEmpty
                userNameTextField.textColor = UIColor.red
                return false
            }
            if (textField.text?.count)! <= 4
            {
                print("不夠5個字元")
                userNameErrorLabel.isHidden = false
                emptySpaceLabel1.isHidden = true
                userNameErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserNameNoCurrect
                userNameTextField.textColor = UIColor.red
                return false
            }else
            {
//                let namePattern = "^[0-9a-zA-Z_]{5,16}+$"
//                let intPattern1 = "^(\\..)+$"
//                let intPattern2 = "^(.\\..)+$"
//                let intPattern3 = "^([A-Z])+$"
//                let intPattern4 = "^[a-z]+$"
//                let intPattern5 = "^[0-9]+$"
//                var intMatcher1: RegexHelperOld!
//                do {
//                    intMatcher1 = try RegexHelperOld(intPattern1)
//                }catch
//                {
//                    print(error)
//                }
//                var intMatcher2: RegexHelperOld!
//                do {
//                    intMatcher2 = try RegexHelperOld(intPattern2)
//                }catch
//                {
//                    print(error)
//                }
//                var intMatcher3: RegexHelperOld!
//                do {
//                    intMatcher3 = try RegexHelperOld(intPattern3)
//                }catch
//                {
//                    print(error)
//                }
//                var intMatcher4: RegexHelperOld!
//                do {
//                    intMatcher4 = try RegexHelperOld(intPattern4)
//                }catch
//                {
//                    print(error)
//                }
//                var intMatcher5: RegexHelperOld!
//                do {
//                    intMatcher5 = try RegexHelperOld(intPattern5)
//                }catch
//                {
//                    print(error)
//                }
//                var nameMatcher: RegexHelperOld!
//                do {
//                    nameMatcher = try RegexHelperOld(namePattern)
//                }catch
//                {
//                    print(error)
//                }
//                if nameMatcher.match(input: userNameTextField.text!)
//                    && !intMatcher1.match(input: userNameTextField.text!)
//                    && !intMatcher2.match(input: userNameTextField.text!)
//                    && !intMatcher3.match(input: userNameTextField.text!)
//                    && !intMatcher4.match(input: userNameTextField.text!)
//                    && !intMatcher5.match(input: userNameTextField.text!)
                if RegexHelper.match(pattern:.account,input:(userNameTextField.text )!)
                {
                    print("有效的名稱")
                    userNameTextField.textColor = UIColor.black
                    userNameErrorLabel.isHidden = true
                    userNameErrorLabel.text = ""
                    emptySpaceLabel1.isHidden = false
                    return true
                }else
                {
                    print("無效的名稱")
                    userNameTextField.textColor = UIColor.red
                    userNameErrorLabel.isHidden = false
                    userNameErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserNameNoCurrect
                    emptySpaceLabel1.isHidden = true
                    return false
                }
            }
            
        }
        if userPhoneTextField == textField
        {
            if (textField.text?.count)! <= 10
            {
                print("不夠11個字元")
                userPhoneErrorLabel.isHidden = false
                emptySpaceLabel2.isHidden = true
                userPhoneErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserPhoneNoCurrect
                userPhoneTextField.textColor = UIColor.red
                return false
            }else
            {
//                let phonePattern = "1[0-9]{10}"
//                let phonePattern = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
                let phonePattern = "^((13|14|15|16|18|19)\\d{9}){1}$"
//                let phonePattern = "^((13[0-9])|(17[0-9])|(14[^4,//D])|(15[^4,//D])|(18[0-9]))//d{8}$|^1(7[0-9])//d{8}$"
                var phoneMatcher: RegexHelperOld!
                do {
                    phoneMatcher = try RegexHelperOld(phonePattern)
                }catch
                {
                    print(error)
                }
                if phoneMatcher.match(input: userPhoneTextField.text!)
                {
                    print("有效的電話號碼")
                    userPhoneTextField.textColor = UIColor.black
                    userPhoneErrorLabel.isHidden = true
                    userPhoneErrorLabel.text = ""
                    emptySpaceLabel2.isHidden = false
                    return true
                }else
                {
                    print("無效的電話號碼")
                    userPhoneTextField.textColor = UIColor.red
                    userPhoneErrorLabel.isHidden = false
                    userPhoneErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserPhoneNoCurrect
                    emptySpaceLabel2.isHidden = true
                    return false
                }
            }
        }
        if userPasswordTextField == textField
        {
//            let passwordPattern = "[0-9a-zA-Z_]{8,20}"
            let passwordPattern = "^[A-Za-z0-9]{8,20}+$"
            let passwordPattern2 = "^\\bPASSWORD\\b"
            let passwordPattern3 = "^\\bPassword\\b"
            let passwordPattern4 = "^\\bPASSW0RD\\b"
            let passwordPattern5 = "^\\bpassw0rd\\b"
            let passwordPattern6 = "^\\bpasswd\\b"
            let passwordPattern7 = "^\\bPassword\\b"
            let intPattern1 = "^(\\..)+$"
            let intPattern2 = "^(.\\..)+$"
            let intPattern3 = "^([A-Z])+$"
            let intPattern4 = "^[a-z]+$"
            let intPattern5 = "^[0-9]+$"
//            "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            var intMatcher1: RegexHelperOld!
            do {
                intMatcher1 = try RegexHelperOld(intPattern1)
            }catch
            {
                print(error)
            }
            var intMatcher2: RegexHelperOld!
            do {
                intMatcher2 = try RegexHelperOld(intPattern2)
            }catch
            {
                print(error)
            }
            var intMatcher3: RegexHelperOld!
            do {
                intMatcher3 = try RegexHelperOld(intPattern3)
            }catch
            {
                print(error)
            }
            var intMatcher4: RegexHelperOld!
            do {
                intMatcher4 = try RegexHelperOld(intPattern4)
            }catch
            {
                print(error)
            }
            var intMatcher5: RegexHelperOld!
            do {
                intMatcher5 = try RegexHelperOld(intPattern5)
            }catch
            {
                print(error)
            }
          
            
            var matcher: RegexHelperOld!
            do {
                matcher = try RegexHelperOld(passwordPattern)
            }catch
            {
                print(error)
            }
            var matcher2: RegexHelperOld!
            do {
                matcher2 = try RegexHelperOld(passwordPattern2)
            }catch
            {
                print(error)
            }
            var matcher3: RegexHelperOld!
            do {
                matcher3 = try RegexHelperOld(passwordPattern3)
            }catch
            {
                print(error)
            }
            var matcher4: RegexHelperOld!
            do {
                matcher4 = try RegexHelperOld(passwordPattern4)
            }catch
            {
                print(error)
            }
            var matcher5: RegexHelperOld!
            do {
                matcher5 = try RegexHelperOld(passwordPattern5)
            }catch
            {
                print(error)
            }
            var matcher6: RegexHelperOld!
            do {
                matcher6 = try RegexHelperOld(passwordPattern6)
            }catch
            {
                print(error)
            }
            var matcher7: RegexHelperOld!
            do {
                matcher7 = try RegexHelperOld(passwordPattern7)
            }catch
            {
                print(error)
            }
            
            if matcher.match(input: userPasswordTextField.text!)
                &&
                !matcher2.match(input: userPasswordTextField.text!) &&
                !matcher3.match(input: userPasswordTextField.text!) &&
                !matcher4.match(input: userPasswordTextField.text!) &&
                !matcher5.match(input: userPasswordTextField.text!) &&
                !matcher6.match(input: userPasswordTextField.text!) &&
                !matcher7.match(input: userPasswordTextField.text!)
                &&
                !intMatcher1.match(input: userPasswordTextField.text!) &&
                !intMatcher2.match(input: userPasswordTextField.text!) &&
                !intMatcher3.match(input: userPasswordTextField.text!) &&
                !intMatcher4.match(input: userPasswordTextField.text!) &&
                !intMatcher5.match(input: userPasswordTextField.text!)
            {
                print("有效的密碼")
                userPasswordErrorLabel.isHidden = true
                emptySpaceLabel4.isHidden = false
                userPasswordErrorLabel.text = ""
                userPasswordTextField.textColor = UIColor.black
                return true
            }else
            {
                print("無效的密碼")
                userPasswordErrorLabel.isHidden = false
                emptySpaceLabel4.isHidden = true
                userPasswordErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserPasswordNoCurrect
                userPasswordTextField.textColor = UIColor.red
                return false
            }
        }
        if userPWConfirmTextField == textField
        {
            if (userPWConfirmTextField.text == userPasswordTextField.text) &&
                ((userPWConfirmTextField.text?.count)! > 0)
            {
                print("有效的確認密碼")
                userReCheckPWErrorLabel.isHidden = true
                emptySpaceLabel5.isHidden = false
                userReCheckPWErrorLabel.text = ""
                userPWConfirmTextField.textColor = UIColor.black
                return true

            }else
            {
                print("無效的確認密碼")
                userReCheckPWErrorLabel.isHidden = false
                emptySpaceLabel5.isHidden = true
                userReCheckPWErrorLabel.text = Constants.Tiger_Text_Cell_ErrorUserRecheckPWNoCurrect
                userPWConfirmTextField.textColor = UIColor.red
                return false
            }
        }
        return false
    }
    // MARK: -----
    // MARK: 確認發送
    @IBAction func confirmToServer(_ sender : UIButton)
    {
        if isTriggerSlider == false
        {
            errorLabel.isHidden = false
            errorLabel.text = Constants.Tiger_Text_Cell_ErrorSliderLocation
            checkMarkErrorLabel.isHidden = false
            checkMarkErrorLabel.text = Constants.Tiger_Text_Cell_ErrorCheckMarkDefault
            spaceLabel.isHidden = true
            resetConfirmButtonRect()
        }else
        {
            errorLabel.isHidden = true
            checkMarkErrorLabel.isHidden = true
            spaceLabel.isHidden = true
        }
        if checkMarkOn == false
        {
            checkMarkErrorLabel.isHidden = false
            checkMarkErrorLabel.text = Constants.Tiger_Text_Cell_ErrorCheckMarkUncheck
            spaceLabel.isHidden = true
            return
        }
        if ( userNameErrorLabel.isHidden == true &&
            userPhoneErrorLabel.isHidden == true &&
            userPasswordErrorLabel.isHidden == true &&
            userReCheckPWErrorLabel.isHidden == true &&
            errorLabel.isHidden == true )
        {
            if isLoginMode == false
            {
                if (CheckTextfieldCharacter(with: userNameTextField) == true) &&
                    (CheckTextfieldCharacter(with: userPhoneTextField) == true) &&
                    (CheckTextfieldCharacter(with: userPasswordTextField) == true) &&
                    (CheckTextfieldCharacter(with: userPWConfirmTextField) == true)
                {
                    print("可以傳送")
                    signUpData = HG_MemberSignUpData(memberName: userNameTextField.text!, memberPhone: userPhoneTextField.text!, memberEmail: "" , memberPassword: userPWConfirmTextField.text!)
                    loginData = HG_MemberLoginData(memberName: userNameTextField.text!, memberPassword: userPasswordTextField.text!)
                    allCheckWellAndFire()
                }else
                {
                    print("不可以傳送")
                }
            }else
            {
                if (CheckTextfieldCharacter(with: userNameTextField) == true) &&
                    (CheckTextfieldCharacter(with: userPasswordTextField) == true)
                {
                    print("可以傳送")
                    loginData = HG_MemberLoginData(memberName: userNameTextField.text!, memberPassword: userPasswordTextField.text!)
                    allCheckWellAndFire()
                }else
                {
                    print("不可以傳送")
                }
            }
        }
        else
        {
            checkMarkErrorLabel.isHidden = false
            checkMarkErrorLabel.text = Constants.Tiger_Text_Cell_ErrorCheckMarkDefault
            spaceLabel.isHidden = true
            return
        }
    }
    func allCheckWellAndFire()
    {
//        登入
        print("檢查完畢 與server 連線")
        let successClo : HG_SuccessClosures = { hgService in
            
            if self.isLoginMode == true
            {
                self.vcDelegate.userDidFinishLogin(withSelfData: self.loginData)
                print("登入ＯＫ")
            }else
            {
//                self.vcDelegate.userDidFinishSignUp(withSelfData: self.signUpData)
                print("註冊ＯＫ")
                self.isLoginMode = true
                self.allCheckWellAndFire()
            }
            
//            self.startFunc(JWT_String: ((hgService as! HG_Verification).jwt_token))
        }
        let failedClo : HG_FailedClosures = { errorData in
            self.hostView.removeBlurView()
            self.hostView.showErrorToast(with: errorData as Any)
        }
        let urlString :String!
        let bodyString :String!
        if isLoginMode == true
        {
            
            urlString = Constants.Tiger_MemberLogin
            let jpushRegisterID = JPUSHService.registrationID() ?? ""
            bodyString = "UserName=\(loginData.memberName)&Password=\(loginData.memberPassword)&Finger=\(loginData.uuid)&KeepData=\(false)&LastLoginRid=\(jpushRegisterID)"

        }else
        {
            urlString = Constants.Tiger_MemberSignUp
            let jpushRegisterID = JPUSHService.registrationID() ?? ""
            bodyString = "UserName=\(signUpData.memberName)&Phone=\(signUpData.memberPhone)&Password=\(signUpData.memberPassword)&Finger=\(signUpData.uuid)&LastLoginRid=\(jpushRegisterID)"
        }
        hostView.addBlurView()
        hostView.addAndStartSpiner()
        let startNetWork :HGService = HGService()
        startNetWork.netTask(withURL: urlString, withPostString:bodyString , successComplete: successClo, failedException: failedClo)
    }
    @IBAction func checkMarkButtonSwitchAction(_ sender : UIButton)
    {
        checkMarkOn = !checkMarkOn
        let onImage = UIImage(named: "web-checkMark")
        if checkMarkOn == true
        {
            checkMarkButton.setImage(onImage, for: .normal)
        }else
        {
            checkMarkButton.setImage(nil, for: .normal)
        }
    }

}
