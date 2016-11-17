//
//  AddContactViewControllerExtension.swift
//  PotatoParty
//
//  Created by Ariela Cohen on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


extension AddContactViewController {
    
    func layoutElements() {
        
       view.backgroundColor = UIColor.white
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(view.frame.height/4)
            make.width.equalToSuperview().multipliedBy(0.60)
            make.height.equalTo(nameTextField.snp.width).multipliedBy(0.25)
        }
        
        nameTextField.backgroundColor = UIColor.blue
        nameTextField.text = "Name"
        
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(nameTextField.snp.bottomMargin).offset(40)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        emailTextField.backgroundColor = UIColor.blue
        emailTextField.text = "example@serviceprovider"
        
        view.addSubview(groupDropDown)
        groupDropDown.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField.snp.bottomMargin).offset(40)
            make.width.equalTo(emailTextField)
            make.height.equalTo(emailTextField)
        }
        
        groupDropDown.backgroundColor = UIColor.blue
       
    }
    
}

