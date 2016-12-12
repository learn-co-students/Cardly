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
    let forgotPasswordButtonTopOffset = 50
    
    let loginBackgroundImage: UIImage = #imageLiteral(resourceName: "loginScreenBackground")
    var cardlyTextLabel: UILabel!
    var cardlyAirplaneImageView: UIImageView!
    var userTextfield: UITextField!
    var passwordTextfield: UITextField!
    var loginButton: UIButton!
    var createAccountButton: UIButton!
    var forgotPasswordButton: UIButton!
    var cardlyDescriptionText: UILabel!
    var orTextLabel: UILabel!

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
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        CustomNotification.show("Password reset e-mail sent")
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
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
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "loginScreenBackground")?.draw(in: view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: image)
        
        userTextfield = CustomTextField.initTextField(placeHolderText: "example@emailprovider.com", isSecureEntry: false)
        view.addSubview(userTextfield)
        userTextfield.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalToSuperview().offset(view.frame.height/4.3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        passwordTextfield = CustomTextField.initTextField(placeHolderText: "Password", isSecureEntry: true)
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(userTextfield.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(userTextfield.snp.width)
            make.height.equalTo(userTextfield.snp.height)
        }
        
        forgotPasswordButton = CardlyFormFieldButton.initButton(title: "Forgot password?", target: self, selector: #selector(forgotPasswordButtonTapped))
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextfield.snp.bottomMargin).offset(forgotPasswordButtonTopOffset)
        }
        
        loginButton = CardlyFormFieldButton.initButton(title: "Login", target: self, selector: #selector(loginButtonTapped))
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(forgotPasswordButton.snp.bottomMargin).offset(loginButtonTopOffset)
        }
        
        createAccountButton = CardlyFormFieldButton.initButton(title: "Create Account", target: self, selector: #selector(createAccountButtonTapped))
        view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(createAccountButtonTopOffset)
        }

        cardlyTextLabel = UILabel()
        cardlyTextLabel.backgroundColor = UIColor.clear
        cardlyTextLabel.text = "Cardly"
        cardlyTextLabel.textAlignment = .center
        cardlyTextLabel.font = UIFont(name: Font.fancy , size: 110)
        cardlyTextLabel.textColor = UIColor.white
        cardlyTextLabel.minimumScaleFactor = 0.5
        cardlyTextLabel.sizeToFit()
        view.addSubview(cardlyTextLabel)
        cardlyTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(12)
        }
        
        cardlyAirplaneImageView = UIImageView()
        cardlyAirplaneImageView.image = Icons.planeIcon
        cardlyAirplaneImageView.contentMode = .scaleAspectFit
        view.addSubview(cardlyAirplaneImageView)
        cardlyAirplaneImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(view.snp.height).multipliedBy(0.06)
            make.leadingMargin.equalTo(cardlyTextLabel.snp.trailingMargin)
            make.topMargin.equalTo(cardlyTextLabel.snp.topMargin)
        }
        
        cardlyDescriptionText = UILabel()
        view.addSubview(cardlyDescriptionText)
        cardlyDescriptionText.backgroundColor = UIColor.clear
        cardlyDescriptionText.text = "Send Video Thank You Cards"
        cardlyDescriptionText.textAlignment = .center
        cardlyDescriptionText.font = UIFont(name: Font.fancy, size: Font.Size.xxl)
        cardlyDescriptionText.textColor = UIColor.white
        cardlyDescriptionText.minimumScaleFactor = 0.5
        cardlyDescriptionText.sizeToFit()
        cardlyDescriptionText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-20)
        }
        
        orTextLabel = UILabel()
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
