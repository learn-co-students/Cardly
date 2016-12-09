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
        
       view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "loginScreenBackground"))
        
//        textfieldStackView.distribution = .fillProportionally
//        textfieldStackView.alignment = .fill
//        textfieldStackView.axis = .vertical
//        textfieldStackView.spacing = 8.0
//        textfieldStackView.backgroundColor = UIColor.clear
//        
//        
//        view.addSubview(textfieldStackView)
//        textfieldStackView.addArrangedSubview(userTextfield)
//        textfieldStackView.addArrangedSubview(passwordTextfield)
//        textfieldStackView.addArrangedSubview(forgotPasswordButton)
//        
//        textfieldStackView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.topMargin.equalToSuperview().offset(300)
//            make.width.equalToSuperview().multipliedBy(0.75)
//            make.height.equalToSuperview().multipliedBy(1/3)
//        }

        view.addSubview(userTextfield)
        userTextfield.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.topMargin.equalToSuperview().offset(view.frame.height/4.3)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        userTextfield.placeholder = "example@emailprovider.com"
        userTextfield.backgroundColor = UIColor.white
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
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.backgroundColor = UIColor.white
        passwordTextfield.textAlignment = .center
        passwordTextfield.autocapitalizationType = UITextAutocapitalizationType.none
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(passwordTextfield.snp.bottomMargin).offset(forgotPasswordButtonTopOffset)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(0.85)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(0.85)
        }
        
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        forgotPasswordButton.backgroundColor = UIColor.clear
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(forgotPasswordButton.snp.bottomMargin).offset(loginButtonTopOffset)
            make.width.equalTo(passwordTextfield.snp.width).multipliedBy(loginButtonToTextFieldWidthMultipier)
            make.height.equalTo(passwordTextfield.snp.height).multipliedBy(loginButtonToTextFieldHeightMultiplier)
            
        }
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.clear
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(loginButton.snp.bottomMargin).offset(createAccountButtonTopOffset)
            make.width.equalTo(forgotPasswordButton.snp.width)
            make.height.equalTo(loginButton.snp.height)
        }
        
        createAccountButton.setTitle("Create account", for: .normal)
        createAccountButton.backgroundColor = UIColor.clear
        createAccountButton.addTarget(self, action: #selector(self.createAccountButtonTapped), for: .touchUpInside)
        createAccountButton.setTitleColor(UIColor.black, for: .normal)
        
        view.addSubview(cardlyTextLabel)
//        cardlyTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cardlyTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
//        cardlyTextLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5).isActive = true
//        cardlyTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//
//        cardlyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardlyTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().multipliedBy(0.09)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(1.0/5.0)
        }
        
        cardlyTextLabel.backgroundColor = UIColor.clear
        cardlyTextLabel.text = "Cardly"
        cardlyTextLabel.textAlignment = .center
        cardlyTextLabel.font = UIFont(name: Font.fancy , size: 110)
        cardlyTextLabel.textColor = UIColor.white
        
        
//        cardlyAirplaneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -130).isActive = true
//        cardlyAirplaneImageView.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
//        cardlyAirplaneImageView.heightAnchor.constraint(equalTo: cardlyTextLabel.heightAnchor).isActive = true
//        cardlyAirplaneImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        cardlyAirplaneImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        cardlyAirplaneImageView.backgroundColor = UIColor.init(patternImage: Icons.planeIcon!)
        
        cardlyAirplaneImageView.image = Icons.planeIcon
        view.addSubview(cardlyAirplaneImageView)

        cardlyAirplaneImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(view.snp.height).multipliedBy(0.06)
            make.topMargin.equalTo(cardlyTextLabel.snp.bottomMargin).offset(-20)
            make.trailingMargin.equalToSuperview().offset(-135)
        }
    }

}
