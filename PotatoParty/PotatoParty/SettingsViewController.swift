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
    var closeButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        view.backgroundColor = Colors.cardlyBlue
        layoutElements()
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Layout view elements
    func layoutElements() {
        closeButton = UIButton()
        view.addSubview(closeButton)
        closeButton.setImage(Icons.backButton, for: .normal)
        closeButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        closeButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.topMargin.equalToSuperview().offset(40)
            make.leadingMargin.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "Settings"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont(name: Font.fancy, size: Font.Size.viewTitle)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowRadius = 0
        titleLabel.layer.shadowOpacity = 1
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(closeButton).offset(-10)
        }
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.text = "Change email"
        emailLabel.minimumScaleFactor = 0.5
        emailLabel.textColor = Colors.cardlyGrey
        emailLabel.textAlignment = .left
        emailLabel.font = UIFont(name: Font.regular, size: Font.Size.xl)
        emailLabel.sizeToFit()
        emailLabel.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview()
            make.topMargin.equalTo(titleLabel.snp.bottomMargin).offset(20)
        }
        
        changeEmailPasswordTextField = UITextField()
        view.addSubview(changeEmailPasswordTextField)
        changeEmailPasswordTextField.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailLabel.snp.bottomMargin).offset(30)
        }
        changeEmailPasswordTextField.placeholder = "Enter current password"
        changeEmailPasswordTextField.textColor = UIColor.black
        changeEmailPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        changeEmailPasswordTextField.textAlignment = .center
        changeEmailPasswordTextField.isSecureTextEntry = true
        
        newEmailTextField = UITextField()
        view.addSubview(newEmailTextField)
        newEmailTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changeEmailPasswordTextField.snp.bottomMargin).offset(30)
        }
        newEmailTextField.autocapitalizationType = .none
        newEmailTextField.textColor = UIColor.black
        newEmailTextField.borderStyle = UITextBorderStyle.roundedRect
        newEmailTextField.placeholder = "Enter new email address"
        newEmailTextField.textAlignment = .center
        
        changeEmailButton = UIButton()
        view.addSubview(changeEmailButton)
        changeEmailButton.setTitle("Submit", for: .normal)
        changeEmailButton.titleLabel?.font = UIFont(name: Font.regular, size: Font.Size.l)
        changeEmailButton.titleLabel?.textColor = UIColor.white
        changeEmailButton.titleLabel?.minimumScaleFactor = 0.5
        changeEmailButton.addTarget(self, action: #selector(changeEmailButtonTapped), for: .touchUpInside)
        changeEmailButton.sizeToFit()
        changeEmailButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(newEmailTextField.snp.bottomMargin).offset(20)
        }
        
        let changeEmailDivider = UIImageView(image: Backgrounds.divider)
        view.addSubview(changeEmailDivider)
        changeEmailDivider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changeEmailButton.snp.bottomMargin).offset(20)
        }
        
        let passwordLabel = UILabel()
        view.addSubview(passwordLabel)
        passwordLabel.text = "Change password"
        passwordLabel.textColor = Colors.cardlyGrey
        passwordLabel.textAlignment = .left
        passwordLabel.font = UIFont(name: Font.regular, size: Font.Size.xl)
        passwordLabel.sizeToFit()
        passwordLabel.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview()
            make.topMargin.equalTo(changeEmailDivider.snp.bottomMargin).offset(30)
        }
        
        currentPasswordTextField = UITextField()
        view.addSubview(currentPasswordTextField)
        currentPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordLabel.snp.bottomMargin).offset(30)
        }
        currentPasswordTextField.textColor = UIColor.black
        currentPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        currentPasswordTextField.placeholder = "Enter current password"
        currentPasswordTextField.textAlignment = .center
        currentPasswordTextField.isSecureTextEntry = true
        
        newPasswordTextField = UITextField()
        view.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
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
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
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
        changePasswordButton.setTitle("Submit", for: .normal)
        changePasswordButton.titleLabel?.font = UIFont(name: Font.regular, size: Font.Size.l)
        changePasswordButton.titleLabel?.textColor = UIColor.white
        changePasswordButton.titleLabel?.minimumScaleFactor = 0.5
        changePasswordButton.sizeToFit()
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        changePasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(confirmNewPasswordTextField.snp.bottomMargin).offset(20)
        }
        
        let changePasswordDivider = UIImageView(image: Backgrounds.divider)
        view.addSubview(changePasswordDivider)
        changePasswordDivider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changePasswordButton.snp.bottomMargin).offset(20)
        }
        
        logoutButton = UIButton()
        view.addSubview(logoutButton)
        logoutButton.setTitle("Log out       ", for: .normal)
        logoutButton.titleLabel?.textAlignment = .left
        logoutButton.titleLabel?.font = UIFont(name: Font.regular, size: Font.Size.l)
        logoutButton.titleLabel?.textColor = UIColor.white
        logoutButton.sizeToFit()
        logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        logoutButton.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview()
            make.topMargin.equalTo(changePasswordDivider.snp.bottomMargin).offset(20)
        }
        
        let logoutDivider = UIImageView(image: Backgrounds.divider)
        view.addSubview(logoutDivider)
        logoutDivider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(logoutButton.snp.bottomMargin).offset(20)
        }
        
        forgotPasswordButton = UIButton()
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.titleLabel?.textAlignment = .left
        forgotPasswordButton.titleLabel?.font = UIFont(name: Font.regular, size: Font.Size.l)
        forgotPasswordButton.titleLabel?.textColor = UIColor.white
        forgotPasswordButton.sizeToFit()
        forgotPasswordButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.leadingMargin.equalToSuperview()
            make.topMargin.equalTo(logoutDivider.snp.bottomMargin).offset(20)
        }
        
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
        if checkIfChangeEmailFieldsValid() {
            attemptEmailChange()
        }
    }
    
    func changePasswordButtonTapped() {
        if checkIfPasswordFieldsValid() {
            attemptPasswordChange()
        }
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
                    CustomNotification.showError(SettingsErrorMessage.authFailed)
                }
                else {
                    self.currentUser?.updateEmail(email, completion: { (error) in
                        if let error = error {
                            switch error {
                            case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
                                DispatchQueue.main.async {
                                    CustomNotification.showError(SettingsErrorMessage.emailAlreadyInUse)
                                }
                            case FIRAuthErrorCode.errorCodeInvalidEmail:
                                DispatchQueue.main.async {
                                    CustomNotification.showError(SettingsErrorMessage.invalidEmail)
                                }
                            default:
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
            if currentPasswordTextField.isEditing || newPasswordTextField.isEditing || confirmNewPasswordTextField.isEditing {
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
