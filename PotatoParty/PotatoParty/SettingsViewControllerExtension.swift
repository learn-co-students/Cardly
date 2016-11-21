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
        view.backgroundColor = UIColor.white
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().dividedBy(2)
        }
        logoutButton.backgroundColor = UIColor.blue
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
    }
    
}
