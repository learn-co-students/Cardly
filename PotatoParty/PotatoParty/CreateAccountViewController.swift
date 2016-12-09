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
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var confirmPasswordTextField: UITextField!
    var submitButton: UIButton!
    var cancelButton: UIButton!
    var cardlyTextLabel: UILabel!
    var cardlyAirplaneImageView: UIImageView!
    var titleLabel: UILabel!
    
    let textFieldToSuperviewWidthMultiplier = 0.6
    let textFieldToSuperviewHeightMultiplier = 0.25
    let emailTextFieldTopOffset = 250
    let passwordTextFieldTopOffset = 40
    let submitButtonToTextFieldWidthMultipier = 1.0/3.0
    let submitButtonToTextFieldHeightMultiplier = 0.5
    let submitButtonTopOffset = 30
    
    var password: String? = nil
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false
    var isConfirmPasswordValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loginScreenBackground"))
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

    
// MARK: - Button methods
    
    func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func submitButtonTapped() {
        if checkIfAllFieldsValid() {
            createUserAccount()
        }
    }
    

// MARK: - Firebase methods
    
    func createUserAccount() {
        if let unwrappedEmail = emailTextField.text, let unwrappedPassword = passwordTextField.text {
            FIRAuth.auth()!.createUser(withEmail: unwrappedEmail, password: unwrappedPassword, completion: { (user, error) in
                if error == nil {
                    self.firebaseSignIn(user: unwrappedEmail, password: unwrappedPassword)
                    
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            CustomNotification.showError(error.localizedDescription)
                        }
                    }
                }
            })
        }
        
    }
    
    func firebaseSignIn(user: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: user, password: password, completion: { (user, error) in
            var errorMsg = "Firebase sign in error"
            if let error = error {
                errorMsg = error.localizedDescription
                let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                self.loginSuccessSegue()
            }
        })
    }
    
    
// MARK: - Layout view elements
    
    func setUpView() {
        emailTextField = CustomTextField.initTextField(placeHolderText: "example@emailprovider.com" , isSecureEntry: false)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalToSuperview().offset(view.frame.height/4.3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
       
        passwordTextField = CustomTextField.initTextField(placeHolderText: "password", isSecureEntry: true)
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(emailTextField.snp.width)
            make.height.equalTo(emailTextField.snp.height)
        }

        confirmPasswordTextField = CustomTextField.initTextField(placeHolderText: "confirm password", isSecureEntry: true)
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextField.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(passwordTextField)
            make.height.equalTo(passwordTextField)
        }
   
        submitButton = CardlyFormFieldButton.initButton(title: "Submit", target: self, selector: #selector(submitButtonTapped))
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(50)
            make.topMargin.equalTo(confirmPasswordTextField.snp.bottomMargin).offset(submitButtonTopOffset)
            make.width.equalTo(confirmPasswordTextField.snp.width).multipliedBy(submitButtonToTextFieldWidthMultipier)
            make.height.equalTo(confirmPasswordTextField.snp.height).multipliedBy(submitButtonToTextFieldHeightMultiplier)
        }

        cancelButton = CardlyFormFieldButton.initButton(title: "Cancel", target: self, selector: #selector(cancelButtonTapped))
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-50)
            make.topMargin.equalTo(confirmPasswordTextField.snp.bottomMargin).offset(submitButtonTopOffset)
            make.width.equalTo(submitButton)
            make.height.equalTo(submitButton)
        }
        
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "Create Account"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont(name: Font.fancy, size: Font.Size.viewTitle/1.2)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.layer.shadowRadius = 0
        titleLabel.layer.shadowOpacity = 1
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(30)
        }
    }
}


// MARK: - UITextField delegate methods

extension CreateAccountViewController {
    
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
            isPasswordValid = validatePassword(text: textField.text!)
            break
        case confirmPasswordTextField:
            isConfirmPasswordValid = validatePasswordConfirm(text: textField.text!)
            break
        default:
            break
        }
    }
    
}


// MARK: - TextField verification methods

extension CreateAccountViewController {
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
            let isMatch = text == password
            if !isMatch {
                CustomNotification.showError(SettingsErrorMessage.confirmPasswordMatch)
            }
            return isMatch
        }
        return false
    }
    
    func checkIfAllFieldsValid() -> Bool {
        if isEmailValid && isPasswordValid && isConfirmPasswordValid {
            return true
        }
        CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
        return false
    }
}

// MARK: - Keyboard methods

extension CreateAccountViewController {
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - Navigation methods

extension CreateAccountViewController {
    
    func loginSuccessSegue() {
        let initialVC = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: initialVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}
