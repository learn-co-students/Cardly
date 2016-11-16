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
        
        view.addSubview(userTextfield)
        userTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset((view.frame.height/3))
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(userTextfield.snp.width).multipliedBy(0.25)
        }
        userTextfield.text = "example@emailprovider"
        userTextfield.backgroundColor = UIColor.blue
        
        view.addSubview(passwordTextfield)
        passwordTextfield.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(userTextfield.snp.bottomMargin).offset(40)
            make.width.equalTo(userTextfield.snp.width)
            make.height.equalTo(userTextfield.snp.height)
        }
        passwordTextfield.text = "password"
        passwordTextfield.backgroundColor = UIColor.blue
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextfield.snp.bottomMargin).offset(30)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(1.0/3.0)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(1.0/2.0)
            
        }
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.blue
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(100)
            make.width.equalTo(userTextfield.snp.width).multipliedBy(0.8)
            make.height.equalTo(loginButton.snp.height)
        }
        createAccountButton.setTitle("Create account", for: .normal)
        createAccountButton.backgroundColor = UIColor.blue
        createAccountButton.addTarget(self, action: #selector(self.createAccountButtonTapped), for: .touchUpInside)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(createAccountButton.snp.bottomMargin).offset(30)
            make.width.equalTo(userTextfield.snp.width).multipliedBy(0.8)
            make.height.equalTo(loginButton.snp.height)
        }
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.backgroundColor = UIColor.blue
        
    }

}
