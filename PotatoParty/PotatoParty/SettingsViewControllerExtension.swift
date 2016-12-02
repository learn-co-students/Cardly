//
//  SettingsViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit

extension SettingsViewController {
    
    func layoutElements() {
        addBlurEffect()
        view.backgroundColor = UIColor.cyan
    //  view.backgroundColor = UIColor.init(patternImage: settingsBackgroundImage)
        
        view.addSubview(logoutButton)
        view.addSubview(changeEmailButton)
        view.addSubview(changePasswordButton)
        
        
        changeEmailButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        changePasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(200)
            make.height.equalToSuperview().multipliedBy(0.1)
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
