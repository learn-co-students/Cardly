//
//  LoginViewExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit

extension LoginViewController {
    
    func layoutViewAndContraints() {
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(userTextfield)
        userTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset((view.frame.height/3))
            make.width.equalToSuperview().multipliedBy(textFieldToSuperviewWidthMultiplier)
            make.height.equalTo(userTextfield.snp.width).multipliedBy(textFieldToSuperviewHeightMultiplier)
        }
        
        userTextfield.placeholder = "example@emailprovider.com"
        userTextfield.backgroundColor = UIColor.cyan
        userTextfield.textAlignment = .center
        userTextfield.autocapitalizationType = UITextAutocapitalizationType.none
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(userTextfield.snp.bottomMargin).offset(passwordTextFieldTopOffset)
            make.width.equalTo(userTextfield.snp.width)
            make.height.equalTo(userTextfield.snp.height)
        }

        passwordTextfield.placeholder = "Password"
        passwordTextfield.backgroundColor = UIColor.cyan
        passwordTextfield.textAlignment = .center
        passwordTextfield.autocapitalizationType = UITextAutocapitalizationType.none
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextfield.snp.bottomMargin).offset(loginButtonTopOffset)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(loginButtonToTextFieldWidthMultipier)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(loginButtonToTextFieldHeightMultiplier)
            
        }
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.blue
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(createAccountButtonTopOffset)
            make.width.equalTo(userTextfield.snp.width).multipliedBy(createAccountButtonWidthMultiplier)
            make.height.equalTo(loginButton.snp.height)
        }
        createAccountButton.setTitle("Create account", for: .normal)
        createAccountButton.backgroundColor = UIColor.blue
        createAccountButton.addTarget(self, action: #selector(self.createAccountButtonTapped), for: .touchUpInside)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(createAccountButton.snp.bottomMargin).offset(forgotPasswordButtonTopOffset)
            make.width.equalTo(createAccountButton.snp.width)
            make.height.equalTo(createAccountButton.snp.height)
        }
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.backgroundColor = UIColor.blue
        forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonTapped), for: .touchUpInside)
        
    }

}
