//
//  CreateAccountViewController.swift
//  PotatoParty
//
//  Created by Ariela Cohen on 12/7/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth



class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    //UI Elements
    
    var emailTextField = CustomTextField.initTextField(placeHolderText: "example@emailprovider.com" , isSecureEntry: false)
    var passwordTextField = CustomTextField.initTextField(placeHolderText: "password", isSecureEntry: true)
    var confirmPasswordTextField = CustomTextField.initTextField(placeHolderText: "confirm password", isSecureEntry: true)
    var submitButton = UIButton()
    var cancelButton = UIButton()
    var cardlyTextLabel = UILabel()
    var cardlyAirplaneImageView = UIImageView()
    
    //Constraints Constants
    
    let textFieldToSuperviewWidthMultiplier = 0.6
    let textFieldToSuperviewHeightMultiplier = 0.25
    let emailTextFieldTopOffset = 250
    let passwordTextFieldTopOffset = 40
    let submitButtonToTextFieldWidthMultipier = 1.0/3.0
    let submitButtonToTextFieldHeightMultiplier = 0.5
    let submitButtonTopOffset = 30
    
    //Validating Email Constants
    
    var email: String? = nil
    var password: String? = nil
    var confirmPassword: String? = nil
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false
    var isConfirmPasswordValid: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // UIText Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            
        case emailTextField:
            
            isEmailValid = validateEmail(text: textField.text!)
            break
            
        case passwordTextField:
            if !validatePassword(text: textField.text!){
                isPasswordValid = false
            }
            else{
                isPasswordValid = true
            }
            break
        case confirmPasswordTextField:
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
    
    
    // Keyboard Method
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Button and Firebase methods
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
        print ("Cancel Button Tapped")
    }
    
    func submitButtonTapped() {
        print("submit button tapped")
        if checkIfPasswordFieldsValid() && checkIfChangeEmailFieldValid() {
            createUserAccount()
        } else {
            DispatchQueue.main.async {
                CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
            }
            
        }
    }
    
    func createUserAccount() {
        if let unwrappedEmail = emailTextField.text, let unwrappedPassword = passwordTextField.text {
            FIRAuth.auth()!.createUser(withEmail: unwrappedEmail, password: unwrappedPassword, completion: { (user, error) in
                if error == nil {
                    self.firebaseSignIn(user: unwrappedEmail, password: unwrappedPassword)
                    
                } else {
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
                            print("Firebase create user error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
                            }
                        }
                    }
                }
            })
        }
        
    }
    
    func firebaseSignIn(user: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: user, password: password, completion: { (user, error) in
            if error == nil {
                self.loginSuccessSegue()
            }
            else {
                print("Firebase sign in error: \(error?.localizedDescription)")
                let alertController = UIAlertController(title: "Error", message: "Email or Password is incorrect", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    // Layout Views and Constraints
    
    func setUpView() {
        
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loginScreenBackground"))
      
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalToSuperview().offset(view.frame.height/4.3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
       
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(emailTextField.snp.width)
            make.height.equalTo(emailTextField.snp.height)
        }

        
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextField.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(passwordTextField)
            make.height.equalTo(passwordTextField)
        }
   
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(50)
            make.topMargin.equalTo(confirmPasswordTextField.snp.bottomMargin).offset(submitButtonTopOffset)
            make.width.equalTo(confirmPasswordTextField.snp.width).multipliedBy(submitButtonToTextFieldWidthMultipier)
            make.height.equalTo(confirmPasswordTextField.snp.height).multipliedBy(submitButtonToTextFieldHeightMultiplier)
        }
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor.clear
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.addTarget(self, action: #selector(self.submitButtonTapped), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-50)
            make.topMargin.equalTo(confirmPasswordTextField.snp.bottomMargin).offset(submitButtonTopOffset)
            make.width.equalTo(submitButton)
            make.height.equalTo(submitButton)
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        
        view.addSubview(cardlyTextLabel)
        cardlyTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalTo(view.snp.topMargin).offset(12)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(view.snp.height).multipliedBy(1.0/5.0)
        }

        cardlyTextLabel.backgroundColor = UIColor.clear
        cardlyTextLabel.text = "Cardly"
        cardlyTextLabel.textAlignment = .center
        cardlyTextLabel.font = UIFont(name: Font.fancy , size: 110)
        cardlyTextLabel.textColor = UIColor.white
        
        cardlyAirplaneImageView.image = Icons.planeIcon
        
        view.addSubview(cardlyAirplaneImageView)
        
        cardlyAirplaneImageView.snp.makeConstraints { (make) in
            make.height.equalTo(view.snp.height).multipliedBy(0.06)
            make.width.equalTo(view.snp.height).multipliedBy(0.06)
            make.topMargin.equalTo(cardlyTextLabel.snp.bottomMargin).offset(-20)
            make.trailingMargin.equalToSuperview().offset(-135)
        }
    }
    
    
    // validating fields
    
    
    func validateEmail(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError(SettingsErrorMessage.emailEmpty)
            return false
        }
        
        if text.contains("@") && text.contains(".") {
            return true
        } else {
            CustomNotification.showError(SettingsErrorMessage.emailFormat)
            return false
        }
    }
    
    func validatePassword(text: String) -> Bool {
        if !(text.characters.count > 0) {
            CustomNotification.showError("Password cannot be empty")
            return false
        }
        if text.characters.count >= 6 {
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
            let isMatch = text == password
            if !isMatch {
                CustomNotification.showError(SettingsErrorMessage.confirmPasswordMatch)
            }
            return isMatch
        }
        return false
    }
    
    func checkIfPasswordFieldsValid() -> Bool{
        if isPasswordValid && isConfirmPasswordValid {
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.changePasswordFieldsNotCorrect)
        return false
    }
    
    func checkIfChangeEmailFieldValid() -> Bool {
        if isEmailValid {
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
        return false
    }
    
}

extension CreateAccountViewController {
    
    func loginSuccessSegue() {
        let initialVC = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: initialVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}





