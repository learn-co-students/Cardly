//
//  ViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController{
    
    // MARK: - Constraint constants
    
    let textFieldToSuperviewWidthMultiplier = 0.6
    let textFieldToSuperviewHeightMultiplier = 0.25
    let passwordTextFieldTopOffset = 40
    let loginButtonToTextFieldWidthMultipier = 1.0/3.0
    let loginButtonToTextFieldHeightMultiplier = 0.5
    let loginButtonTopOffset = 30
    let createAccountButtonTopOffset = 50
    let createAccountButtonWidthMultiplier = 0.8
    let forgotPasswordButtonTopOffset = 18
    let loginBackgroundImage: UIImage = #imageLiteral(resourceName: "loginScreenBackground")
    
    let cardlyTextLabel = UILabel()
    let cardlyAirplaneImageView = UIImageView()
    
    var userTextfield = CustomTextField.initTextField(placeHolderText: "example@emailprovider.com", isSecureEntry: false)
    var passwordTextfield = CustomTextField.initTextField(placeHolderText: "Password", isSecureEntry: true)
    var loginButton = CardlyFormFieldButton.initButton(title: "Login", target: self, selector: #selector(loginButtonTapped))
    var createAccountButton = CardlyFormFieldButton.initButton(title: "Create Account", target: self, selector: #selector(createAccountButtonTapped))
    var forgotPasswordButton = UIButton()
    var textfieldStackView = UIStackView()
    var cardlyDescriptionText = UILabel()
    var orTextLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViewAndContraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextfield {
            userTextfield.becomeFirstResponder()
        }
        if textField == passwordTextfield {
            textField.resignFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: - Firebase account methods

extension LoginViewController {
    
    func createAccountButtonTapped() {
        let destVC = CreateAccountViewController()
        destVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
    }
    
    func loginButtonTapped() {
        firebaseSignIn(user: userTextfield.text!, password: passwordTextfield.text!)
    }
    
    func firebaseSignIn(user: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: user, password: password, completion: { (user, error) in
            if error == nil {
                self.loginSuccessSegue()
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "Email or Password is incorrect", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
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
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


// MARK: - Navigation methods

extension LoginViewController {
    
    func loginSuccessSegue() {
        let initialVC = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: initialVC)
        present(navigationController, animated: true, completion: nil)
    }

}

extension LoginViewController{

    func layoutViewAndContraints() {
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loginScreenBackground"))
        
        view.addSubview(userTextfield)
        userTextfield.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalToSuperview().offset(view.frame.height/4.3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(userTextfield.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(userTextfield.snp.width)
            make.height.equalTo(userTextfield.snp.height)
        }
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextfield.snp.bottomMargin).offset(forgotPasswordButtonTopOffset)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(0.85)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(0.85)
        }

        forgotPasswordButton.titleLabel!.font = UIFont(name: Font.regular, size: Font.Size.m)
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.titleLabel!.minimumScaleFactor = 0.5
        forgotPasswordButton.sizeToFit()
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(forgotPasswordButton.snp.bottomMargin).offset(loginButtonTopOffset)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(loginButtonToTextFieldWidthMultipier)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(loginButtonToTextFieldHeightMultiplier)
            
        }
        
        view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(createAccountButtonTopOffset)
            make.width.equalTo(forgotPasswordButton.snp.width)
            make.height.equalTo(loginButton.snp.height)
        }

        view.addSubview(cardlyTextLabel)
        
        cardlyTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(12)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(1.0/5.0)
        }
        
        cardlyTextLabel.backgroundColor = UIColor.clear
        cardlyTextLabel.text = "Cardly"
        cardlyTextLabel.textAlignment = .center
        cardlyTextLabel.font = UIFont(name: Font.fancy , size: 110)
        cardlyTextLabel.textColor = UIColor.white
        
        
        cardlyAirplaneImageView.image = Icons.planeIcon
        view.addSubview(cardlyAirplaneImageView)
        
        cardlyAirplaneImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(view.snp.height).multipliedBy(0.06)
            make.topMargin.equalTo(cardlyTextLabel.snp.bottomMargin).offset(-20)
            make.trailingMargin.equalToSuperview().offset(-135)
        }
        
        view.addSubview(cardlyDescriptionText)
        cardlyDescriptionText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1/0.6)
        }
        
        cardlyDescriptionText.backgroundColor = UIColor.clear
        cardlyDescriptionText.text = "Send Video Thank You Cards"
        cardlyDescriptionText.textAlignment = .center
        cardlyDescriptionText.font = UIFont(name: Font.fancy, size: 50)
        cardlyDescriptionText.textColor = UIColor.white
        
        
        view.addSubview(orTextLabel)
        orTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(20)
            make.width.equalTo(loginButton.snp.width).multipliedBy(0.5)
            make.height.equalTo(loginButton.snp.height)
        }
        
        orTextLabel.backgroundColor = UIColor.clear
        orTextLabel.text = "or"
        orTextLabel.textAlignment = .center
        orTextLabel.font = UIFont(name: Font.regular, size: 15)
        orTextLabel.textColor = UIColor.black
    }
    
}

