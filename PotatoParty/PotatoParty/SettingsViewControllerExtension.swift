//
//  SettingsViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit
import SnapKit

extension SettingsViewController {
    
    func layoutElements() {
        
        addBlurEffect()
        view.backgroundColor = UIColor.clear
        //  view.backgroundColor = UIColor.init(patternImage: settingsBackgroundImage)
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(80)
            emailLabel.text = "Change email address"
            emailLabel.textColor = UIColor.white
            emailLabel.textAlignment = .center
            emailLabel.font = UIFont(name: Font.nameForCard, size: 60)
            
            let newEmailText: String = "Enter new email address"
            let newEmailPlaceholder = NSAttributedString(string: newEmailText, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            newEmailTextField = UITextField()
            view.addSubview(newEmailTextField)
            newEmailTextField.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalToSuperview().multipliedBy(0.6)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(emailLabel.snp.bottomMargin).offset(40)
            }
            newEmailTextField.textColor = UIColor.black
            newEmailTextField.borderStyle = UITextBorderStyle.roundedRect
            newEmailTextField.attributedPlaceholder = newEmailPlaceholder
            newEmailTextField.textAlignment = .center
            newEmailTextField.clearsOnBeginEditing = true
            
            changeEmailButton = UIButton()
            view.addSubview(changeEmailButton)
            changeEmailButton.snp.makeConstraints { (make) in
                make.width.equalToSuperview().dividedBy(2)
                make.height.equalTo(newEmailTextField.snp.height).offset(-5)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(newEmailTextField.snp.bottomMargin).offset(20)
            }
            changeEmailButton.setTitle("Submit", for: .normal)
            changeEmailButton.titleLabel?.textColor = UIColor.white
            changeEmailButton.addTarget(self, action: #selector(self.changeEmailButtonTapped(_sender:)), for: .touchUpInside)
            changeEmailButton.isEnabled = false
            
            let passwordLabel = UILabel()
            view.addSubview(passwordLabel)
            passwordLabel.snp.makeConstraints { (make) in
                make.size.equalTo(emailLabel.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(changeEmailButton.snp.bottomMargin).offset(40)
            }
            passwordLabel.text = "Change password"
            passwordLabel.textColor = UIColor.white
            passwordLabel.textAlignment = .center
            passwordLabel.font = UIFont(name: Font.nameForCard, size: 60)
            
            let currentPasswordText: String = "Enter current password"
            let currentPasswordPlaceholder = NSAttributedString(string: currentPasswordText, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            currentPasswordTextField = UITextField()
            view.addSubview(currentPasswordTextField)
            currentPasswordTextField.snp.makeConstraints { (make) in
                make.size.equalTo(newEmailTextField.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(passwordLabel.snp.bottomMargin).offset(40)
            }
            currentPasswordTextField.textColor = UIColor.black
            currentPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
            currentPasswordTextField.attributedPlaceholder = currentPasswordPlaceholder
            currentPasswordTextField.textAlignment = .center
            currentPasswordTextField.clearsOnBeginEditing = true
            currentPasswordTextField.isSecureTextEntry = true
            
            let newPasswordText: String = "Enter new password"
            let newPasswordPlaceholder = NSAttributedString(string: newPasswordText, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            newPasswordTextField = UITextField()
            view.addSubview(newPasswordTextField)
            newPasswordTextField.snp.makeConstraints { (make) in
                make.size.equalTo(newEmailTextField.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(currentPasswordTextField.snp.bottomMargin).offset(30)
            }
            newPasswordTextField.textColor = UIColor.black
            newPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
            newPasswordTextField.attributedPlaceholder = newPasswordPlaceholder
            newPasswordTextField.textAlignment = .center
            newPasswordTextField.clearsOnBeginEditing = true
            newPasswordTextField.isSecureTextEntry = true
            
            let confirmNewPasswordText = "Confirm new password"
            let confirmNewPasswordPlaceholder = NSAttributedString(string: confirmNewPasswordText, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            confirmNewPasswordTextField = UITextField()
            view.addSubview(confirmNewPasswordTextField)
            confirmNewPasswordTextField.snp.makeConstraints { (make) in
                make.size.equalTo(newEmailTextField.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(newPasswordTextField.snp.bottomMargin).offset(30)
            }
            confirmNewPasswordTextField.textColor = UIColor.black
            confirmNewPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
            confirmNewPasswordTextField.attributedPlaceholder = confirmNewPasswordPlaceholder
            confirmNewPasswordTextField.textAlignment = .center
            confirmNewPasswordTextField.clearsOnBeginEditing = true
            confirmNewPasswordTextField.isSecureTextEntry = true
            
            changePasswordButton = UIButton()
            view.addSubview(changePasswordButton)
            changePasswordButton.snp.makeConstraints { (make) in
                make.size.equalTo(changeEmailButton.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(confirmNewPasswordTextField.snp.bottomMargin).offset(20)
            }
            changePasswordButton.setTitle("Submit", for: .normal)
            changePasswordButton.titleLabel?.textColor = UIColor.white
            changePasswordButton.addTarget(self, action: #selector(self.changePasswordButtonTapped(_sender:)), for: .touchUpInside)
            changePasswordButton.isEnabled = false
            
            logoutButton = UIButton()
            view.addSubview(logoutButton)
            logoutButton.snp.makeConstraints { (make) in
                make.size.equalTo(changeEmailButton.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(changePasswordButton.snp.bottomMargin).offset(40)
            }
            logoutButton.setTitle("Log out", for: .normal)
            logoutButton.titleLabel?.textColor = UIColor.white
            
            logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
            
            forgotPasswordButton = UIButton()
            view.addSubview(forgotPasswordButton)
            forgotPasswordButton.snp.makeConstraints { (make) in
                make.size.equalTo(changeEmailButton.snp.size)
                make.centerX.equalToSuperview()
                make.topMargin.equalTo(logoutButton.snp.bottomMargin).offset(5)
            }
            forgotPasswordButton.setTitle("Forgot password?", for: .normal)
            forgotPasswordButton.titleLabel?.textColor = UIColor.white
            forgotPasswordButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
            
        }
    }
}
