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



class CreateAccountViewController: UIViewController {
    
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var submitButton = UIButton()
    var cancelButton = UIButton()
    
    //Constraints Constants
    let textFieldToSuperviewWidthMultiplier = 0.6
    let textFieldToSuperviewHeightMultiplier = 0.25
    let emailTextFieldTopOffset = 250
    let passwordTextFieldTopOffset = 40
    let submitButtonToTextFieldWidthMultipier = 1.0/3.0
    let submitButtonToTextFieldHeightMultiplier = 0.5
    let submitButtonTopOffset = 30
    
    //validating Email
    
    var email: String? = nil
    var password: String? = nil
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
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
    
        default:
            break
        }
    }


    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func submitButtonTapped(){
        print("submit button tapped")
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
                                CustomNotification.showError("Error: \(error.localizedDescription)")
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
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(emailTextFieldTopOffset)
            make.width.equalToSuperview().multipliedBy(textFieldToSuperviewWidthMultiplier)
            make.height.equalTo(emailTextField.snp.width).multipliedBy(textFieldToSuperviewHeightMultiplier)
        }
        
        emailTextField.placeholder = "example@emailprovider.com"
        emailTextField.backgroundColor = UIColor.cyan
        emailTextField.textAlignment = .center
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(emailTextField.snp.width)
            make.height.equalTo(emailTextField.snp.height)
        }
        
        passwordTextField.placeholder = "password"
        passwordTextField.backgroundColor = UIColor.cyan
        passwordTextField.textAlignment = .center
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextField.snp.bottomMargin).offset(submitButtonTopOffset)
            make.width.equalTo(passwordTextField.snp.width).multipliedBy(submitButtonToTextFieldWidthMultipier)
            make.height.equalTo(passwordTextField.snp.height).multipliedBy(submitButtonToTextFieldHeightMultiplier)
        }
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor.blue
        submitButton.addTarget(self, action: #selector(self.submitButtonTapped), for: .touchUpInside)
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
            CustomNotification.showError(SettingsErrorMessage.newPasswordEmpty)
            return false
        }
        if text.characters.count >= 6 {
            return true
    }
        CustomNotification.showError(SettingsErrorMessage.passwordLength)
        return false
    }

    
//    func checkIfPasswordFieldsValid() -> Bool{
//        if  isPasswordValid {
//            return true
//        }
//        CustomNotification.showError(SettingsErrorMessage.changePasswordFieldsNotCorrect)
//        return false
//    }
//    
//    func checkIfEmailFieldsValid() -> Bool {
//        if isEmailValid {
//            return true
//        }
//        CustomNotification.showError(SettingsErrorMessage.changeEmailFieldsNotCorrect)
//        return false
//    }


}

extension CreateAccountViewController {
    
    func loginSuccessSegue() {
        let initialVC = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: initialVC)
        present(navigationController, animated: true, completion: nil)
    }
    
}





