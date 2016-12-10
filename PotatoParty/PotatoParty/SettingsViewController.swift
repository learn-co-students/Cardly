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
    let shared = User.shared
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
        
        changeEmailPasswordTextField = CustomTextField.initTextField(placeHolderText: "Enter current password", isSecureEntry: true)
        view.addSubview(changeEmailPasswordTextField)
        changeEmailPasswordTextField.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailLabel.snp.bottomMargin).offset(30)
        }
        
        newEmailTextField = CustomTextField.initTextField(placeHolderText: "Enter new email address", isSecureEntry: false)
        view.addSubview(newEmailTextField)
        newEmailTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(changeEmailPasswordTextField.snp.bottomMargin).offset(30)
        }
        
        changeEmailButton = CardlyFormFieldButton.initButton(title: "Submit", target: self, selector: #selector(changeEmailButtonTapped))
        view.addSubview(changeEmailButton)
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
        
        currentPasswordTextField = CustomTextField.initTextField(placeHolderText: "Enter current password", isSecureEntry: true)
        view.addSubview(currentPasswordTextField)
        currentPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordLabel.snp.bottomMargin).offset(30)
        }
        
        newPasswordTextField = CustomTextField.initTextField(placeHolderText: "Enter new password", isSecureEntry: true)
        view.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(currentPasswordTextField.snp.bottomMargin).offset(30)
        }
        
        confirmNewPasswordTextField = CustomTextField.initTextField(placeHolderText: "Confirm new password", isSecureEntry: true)
        view.addSubview(confirmNewPasswordTextField)
        confirmNewPasswordTextField.snp.makeConstraints { (make) in
            make.size.equalTo(changeEmailPasswordTextField.snp.size)
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(newPasswordTextField.snp.bottomMargin).offset(30)
        }
        
        changePasswordButton = CardlyFormFieldButton.initButton(title: "Submit", target: self, selector: #selector(changePasswordButtonTapped))
        view.addSubview(changePasswordButton)
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
        
        logoutButton = CardlyFormFieldButton.initButton(title: "Log out", target: self, selector: #selector(logout))
        view.addSubview(logoutButton)
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
        
        forgotPasswordButton = CardlyFormFieldButton.initButton(title: "Forgot password?", target: self, selector: #selector(forgotPasswordButtonTapped))
        view.addSubview(forgotPasswordButton)
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
                self.shared.contacts = []
                self.shared.selectedContacts = []
                self.navigationController?.viewControllers.removeAll()
            })
        } catch {
            print("Logout error = (error.localizedDescription)")
        }
    }
    
    func forgotPasswordButtonTapped() {
        
        let alertController = UIAlertController(title: "Enter E-Mail", message: "We'll send you a password reset e-mail", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Send", style: .default) { (action) in
            let emailField = alertController.textFields![0]
            if let email = emailField.text {
                
                FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        CustomNotification.show("Password reset e-mail sent")
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter E-mail"
        }
        
        self.present(alertController, animated: true, completion: nil)
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
