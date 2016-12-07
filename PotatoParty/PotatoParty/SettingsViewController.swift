//
//  SettingsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // Buttons
    var changeEmailButton: UIButton!
    var changePasswordButton: UIButton!
    var logoutButton: UIButton!
    var forgotPasswordButton: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    // Textfields
    var changeEmailPasswordTextField: UITextField!
    var newEmailTextField: UITextField!
    var currentPasswordTextField: UITextField!
    var newPasswordTextField: UITextField!
    var confirmNewPasswordTextField: UITextField!
    
    lazy var textFields: [UITextField] = [self.changeEmailPasswordTextField, self.newEmailTextField, self.currentPasswordTextField, self.newPasswordTextField, self.confirmNewPasswordTextField]
    
    // validate textfield content
    var email: String?
    var emailPassword: String?
    var currentPassword: String?
    var password: String?
    var isEmailPasswordValid: Bool = false
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false
    var isCurrentPasswordValid: Bool = false
    var isConfirmPasswordValid: Bool = false
    
    let currentUser = FIRAuth.auth()?.currentUser
    
    //  var settingsBackgroundImage: UIImage = #imageLiteral(resourceName: "contactsAndSettingsVCBackgroundImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        registerForKeyboardNotifications()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let closeBtn = UIButton()
        self.view.addSubview(closeBtn)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(35)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
        //        dismissButton = {
        //            let button = UIButton(frame: .zero)
        //            button.setImage(UIImage(named: "ic_menu"), for: .normal)
        //            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        //            return button
        //        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = ""
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    // MARK - Textfield aimations
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout view elements
    func layoutElements() {
        
        addBlurEffect()
        view.backgroundColor = UIColor.clear
        //  view.backgroundColor = UIColor.init(patternImage: settingsBackgroundImage)
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(80)
            emailLabel.text = "Change email"
            emailLabel.textColor = UIColor.white
            emailLabel.textAlignment = .center
            emailLabel.font = UIFont(name: Font.nameForCard, size: 60)
        }
        
        changeEmailPasswordTextField = UITextField()
        view.addSubview(changeEmailPasswordTextField)
        changeEmailPasswordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailLabel.snp.bottomMargin).offset(20)
        }
        changeEmailPasswordTextField.placeholder = "Enter current password"
        changeEmailPasswordTextField.textColor = UIColor.black
        changeEmailPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        changeEmailPasswordTextField.textAlignment = .center
        changeEmailPasswordTextField.isSecureTextEntry = true
        
        newEmailTextField = UITextField()
        view.addSubview(newEmailTextField)
        newEmailTextField.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changeEmailPasswordTextField.snp.bottomMargin).offset(30)
        }
        newEmailTextField.textColor = UIColor.black
        newEmailTextField.borderStyle = UITextBorderStyle.roundedRect
        newEmailTextField.placeholder = "Enter new email address"
        newEmailTextField.textAlignment = .center
        
        changeEmailButton = UIButton()
        view.addSubview(changeEmailButton)
        changeEmailButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(newEmailTextField.snp.height).offset(-5)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(newEmailTextField.snp.bottomMargin).offset(20)
        }
        changeEmailButton.setTitle("Submit", for: .normal)
        changeEmailButton.titleLabel?.textColor = UIColor.white
        changeEmailButton.addTarget(self, action: #selector(changeEmailButtonTapped), for: .touchUpInside)
        
        let passwordLabel = UILabel()
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { (make) in
            make.size.equalTo(emailLabel.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changeEmailButton.snp.bottomMargin).offset(20)
        }
        passwordLabel.text = "Change password"
        passwordLabel.textColor = UIColor.white
        passwordLabel.textAlignment = .center
        passwordLabel.font = UIFont(name: Font.nameForCard, size: 60)
        
        currentPasswordTextField = UITextField()
        view.addSubview(currentPasswordTextField)
        currentPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(newEmailTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordLabel.snp.bottomMargin).offset(20)
        }
        currentPasswordTextField.textColor = UIColor.black
        currentPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        currentPasswordTextField.placeholder = "Enter current password"
        currentPasswordTextField.textAlignment = .center
        currentPasswordTextField.isSecureTextEntry = true
        
        newPasswordTextField = UITextField()
        view.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(newEmailTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(currentPasswordTextField.snp.bottomMargin).offset(30)
        }
        newPasswordTextField.textColor = UIColor.black
        newPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        newPasswordTextField.placeholder = "Enter new password"
        newPasswordTextField.textAlignment = .center
        newPasswordTextField.isSecureTextEntry = true
        
        confirmNewPasswordTextField = UITextField()
        view.addSubview(confirmNewPasswordTextField)
        confirmNewPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(newEmailTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(newPasswordTextField.snp.bottomMargin).offset(30)
        }
        confirmNewPasswordTextField.textColor = UIColor.black
        confirmNewPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        confirmNewPasswordTextField.placeholder = "Confirm new password"
        confirmNewPasswordTextField.textAlignment = .center
        confirmNewPasswordTextField.isSecureTextEntry = true
        
        changePasswordButton = UIButton()
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailButton.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(confirmNewPasswordTextField.snp.bottomMargin).offset(20)
        }
        changePasswordButton.setTitle("Submit", for: .normal)
        changePasswordButton.titleLabel?.textColor = UIColor.white
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        
        logoutButton = UIButton()
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailButton.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changePasswordButton.snp.bottomMargin).offset(40)
        }
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.titleLabel?.textColor = UIColor.white
        
        logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        forgotPasswordButton = UIButton()
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailButton.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(logoutButton.snp.bottomMargin).offset(5)
        }
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.titleLabel?.textColor = UIColor.white
        forgotPasswordButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    // MARK: - Background Methods
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    // MARK: - Button Methods
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            present(LoginViewController(), animated: true, completion: {
                self.navigationController?.viewControllers.removeAll()
            })
        } catch {
            print("Logout error = (error.localizedDescription)")
        }
    }
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    func changeEmailButtonTapped() {
        print("Change email submit button tapped")
        if checkIfChangeEmailFieldsValid() {
            attemptEmailChange()
        }
    }
    
    
    func changePasswordButtonTapped() {
        print("Change password submit button tapped")
        if checkIfPasswordFieldsValid() {
            attemptPasswordChange()
        }
    }
    
}

// MARK: - Settings Animation

extension SettingsViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
    
}

// MARK: - UITextField delegate methods

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case changeEmailPasswordTextField:
            isEmailPasswordValid = validateCurrentPasswordForChangeEmail(text: textField.text!)
            break
        case newEmailTextField:
            isEmailValid = validateEmail(text: textField.text!)
            break
        case currentPasswordTextField:
            isCurrentPasswordValid = validateCurrentPassword(text: textField.text!)
            break
        case newPasswordTextField:
            if !validateNewPassword(text: textField.text!){
                isPasswordValid = false
            }
            else{
                isPasswordValid = true
            }
            break
        case confirmNewPasswordTextField:
            if !validatePasswordConfirm(text: textField.text!){
                isConfirmPasswordValid = false
            }
            else{
                isConfirmPasswordValid = true
            }
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case newEmailTextField:
            changeEmailButtonTapped()
        case confirmNewPasswordTextField:
            changePasswordButtonTapped()
        default:
             break
        }

        newEmailTextField.resignFirstResponder() //Hide the keyboard
        return true
    }
}

// MARK: - Form field validation methods

extension SettingsViewController {
    
    func validateEmail(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.emailEmpty)
            return false
        }
        if text.contains("@") && text.contains(".") {
            email = text
            return true
        }
        else {
            CustomNotification.showError(SettingsErrorMessage.emailFormat)
            return false
        }
    }
    
    func validateCurrentPasswordForChangeEmail(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.passwordEmpty)
            return false
        }
        emailPassword = text
        return true
    }
    
    func validateCurrentPassword(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.passwordEmpty)
            return false
        }
        currentPassword = text
        return true
    }
    
    func validateNewPassword(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.newPasswordEmpty)
            return false
        }
        if text.characters.count >= 6{
            password = text
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.passwordLength)
        return false
    }
    
    func validatePasswordConfirm(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.confirmPasswordEmpty)
            return false
        }
        if let password = password {
            let isMatch =  text == password
            if !isMatch {
                CustomNotification.showError(SettingsErrorMessage.confirmPasswordMatch)
            }
            return isMatch
        }
        return false
    }
    
    func checkIfPasswordFieldsValid() -> Bool{
        if isCurrentPasswordValid && isPasswordValid && isConfirmPasswordValid {
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.changePasswordFieldsNotCorrect)
        return false
    }
    
    func checkIfChangeEmailFieldsValid() -> Bool {
        if isEmailValid && isEmailPasswordValid {
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
        return false
    }
    
    func attemptPasswordChange() {
        if let currentPassword = currentPassword, let newPassword = password {
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: (currentUser?.email)!, password: currentPassword)
            currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    CustomNotification.showError(SettingsErrorMessage.authFailed)
                }
                else {
                    self.currentUser?.updatePassword(newPassword, completion: { (error) in
                        if error != nil {
                            CustomNotification.showError(SettingsErrorMessage.passwordUpdate)
                        }
                        else {
                            CustomNotification.show(SettingsSuccessMessage.emailChanged)
                        }
                    })
                }
            })
        }
    }
    
    func attemptEmailChange() {
        if let email = email, let password = emailPassword {
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: (currentUser?.email)!, password: password)
            currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    print("Firebase auth error \(error?.localizedDescription)")
                }
                else {
                    self.currentUser?.updateEmail(email, completion: { (error) in
                        if let error = error {
                            switch error {
                            case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
                                print("email already in use")
                                DispatchQueue.main.async {
                                    CustomNotification.showError(SettingsErrorMessage.emailAlreadyInUse)
                                }
                            case FIRAuthErrorCode.errorCodeInvalidEmail:
                                print("email is invalid")
                                DispatchQueue.main.async {
                                    CustomNotification.showError(SettingsErrorMessage.invalidEmail)
                                }
                            default:
                                print("Error changing email \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    CustomNotification.showError(SettingsErrorMessage.generalEmail)
                                }
                            }
                        }
                        else {
                            CustomNotification.show(SettingsSuccessMessage.emailChanged)
                        }
                    })
                }
            })
        }
    }

}

// MARK: - Keyboard methods

extension SettingsViewController {
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if newPasswordTextField.isEditing || confirmNewPasswordTextField.isEditing {
                self.view.window?.frame.origin.y = -1 * keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if self.view.window?.frame.origin.y != 0 {
                self.view.window?.frame.origin.y += keyboardHeight
            }
        }
    }
}

// MARK: - Tap gesture methods

extension SettingsViewController {
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


