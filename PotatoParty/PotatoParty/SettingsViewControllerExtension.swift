//
//  SettingsViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit

extension SettingsViewController {
    
    // MARK - Change Email & Password Methods
    
    func changeEmail() {
        let newEmailPlaceholder = NSAttributedString(string: "Enter New Email", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        newEmailTextField = UITextField(frame: CGRect(x: self.view.bounds.width * -0.6, y: self.view.bounds.height * 0.20, width: self.view.bounds.width * 0.6, height: self.view.bounds.height * 0.06))
        newEmailTextField.isHidden = true
        newEmailTextField.textColor = UIColor.black
        newEmailTextField.borderStyle = UITextBorderStyle.roundedRect
        
        newEmailLabel = UILabel(frame: .init(x: 50, y: 100, width: 200, height: 20))
        newEmailTextField.attributedPlaceholder = newEmailPlaceholder
        newEmailTextField.clearsOnBeginEditing = true
        view.addSubview(newEmailTextField)
        view.addSubview(newEmailLabel)
    }
    
    func changePassword() {
        let currentPasswordPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        let newPasswordPlaceholder = NSAttributedString(string: "New Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        let confirmNewPasswordPlaceholder = NSAttributedString(string: "Confirm New Password", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        currentPasswordTextField = UITextField(frame: CGRect(x: self.view.bounds.width * -0.6, y: self.view.bounds.height * 0.45, width: self.view.bounds.width * 0.6, height: self.view.bounds.height * 0.06))
        currentPasswordTextField.isHidden = true
        
        newPasswordTextField = UITextField(frame: CGRect(x: self.view.bounds.width * -0.6, y: self.view.bounds.height * 0.53, width: self.view.bounds.width * 0.6, height: self.view.bounds.height * 0.06))
        newPasswordTextField.isHidden = true
        
        confirmNewPasswordTextField = UITextField(frame: CGRect(x: self.view.bounds.width * -0.6, y: self.view.bounds.height * 0.60, width: self.view.bounds.width * 0.6, height: self.view.bounds.height * 0.06))
        confirmNewPasswordTextField.isHidden = true
        
        currentPasswordTextField.textColor = UIColor.black
        newPasswordTextField.textColor = UIColor.black
        confirmNewPasswordTextField.textColor = UIColor.black
        
        currentPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        newPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        confirmNewPasswordTextField.borderStyle = UITextBorderStyle.roundedRect
        
        currentPasswordLabel = UILabel(frame: .init(x: 100, y: 200, width: 200, height: 20))
        newPasswordLabel = UILabel(frame: .init(x: 100, y: 250, width: 200, height: 20))
        confirmNewPasswordLabel = UILabel(frame: .init(x: 100, y: 300, width: 200, height: 20))
        
        currentPasswordTextField.attributedPlaceholder = currentPasswordPlaceholder
        newPasswordTextField.attributedPlaceholder = newPasswordPlaceholder
        confirmNewPasswordTextField.attributedPlaceholder = confirmNewPasswordPlaceholder
        
        currentPasswordTextField.clearsOnBeginEditing = true
        newPasswordTextField.clearsOnBeginEditing = true
        confirmNewPasswordTextField.clearsOnBeginEditing = true
        
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmNewPasswordTextField)
        
        view.addSubview(currentPasswordLabel)
        view.addSubview(newPasswordLabel)
        view.addSubview(confirmNewPasswordLabel)
        
    }
    
    // MARK - Additional View Elements (background, buttons)
    
    func layoutElements() {
        
        // MARK - Background
        addBlurEffect()
        view.backgroundColor = UIColor.cyan
        changeEmail()
        changePassword()
        //  view.backgroundColor = UIColor.init(patternImage: settingsBackgroundImage)
        
        // Mark - Buttons
        view.addSubview(logoutButton)
        view.addSubview(changeEmailButton)
        view.addSubview(changePasswordButton)
        
        changeEmailButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-230)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        changePasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(225)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        changeEmailButton.backgroundColor = UIColor.red
        changeEmailButton.setTitle("Change Email", for: .normal)
        changeEmailButton.addTarget(self, action: #selector(self.changeEmailButtonTapped(_sender:)), for: .touchUpInside)
        
        changePasswordButton.backgroundColor = UIColor.darkGray
        changePasswordButton.setTitle("Change Password", for: .normal)
        changePasswordButton.addTarget(self, action: #selector(self.changePasswordButtonTapped(_sender:)), for: .touchUpInside)
        
        logoutButton.backgroundColor = UIColor.blue
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        
        
    }
    
}
