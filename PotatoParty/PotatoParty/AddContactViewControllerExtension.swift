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
        
        backButton = UIButton()
        view.addSubview(backButton)
        backButton.setImage(Icons.backButton, for: .normal)
        backButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.topMargin.equalToSuperview().offset(40)
            make.leadingMargin.equalToSuperview()
        }
        
        view.backgroundColor = Colors.cardlyBlue
        
        view.addSubview(backgroundPlaneImage)
        backgroundPlaneImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(transparentCenterSubview)
        transparentCenterSubview.backgroundColor = UIColor(white: 1, alpha: 0.5)
        transparentCenterSubview.layer.borderColor = Colors.cardlyGold.cgColor
        transparentCenterSubview.layer.borderWidth = 1.0
        transparentCenterSubview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "Add Contacts"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont(name: Font.fancy, size: Font.Size.viewTitle)
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 3
        titleLabel.layer.shadowOpacity = 1
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(backButton).offset(45)
        }
        
        nameTextField = CustomTextField.initTextField(placeHolderText: "Contact Name", isSecureEntry: false)
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(275)
            make.width.equalToSuperview().multipliedBy(0.60)
            make.height.equalTo(nameTextField.snp.width).multipliedBy(0.15)
        }
        
        
        // E-Mail Textfield
        emailTextField = CustomTextField.initTextField(placeHolderText: "Contact Email", isSecureEntry: false)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(nameTextField).offset(45)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Add Phone Number Textfield
        phoneTextField = CustomTextField.initTextField(placeHolderText: "Contact Phone Number", isSecureEntry: false)
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField).offset(45)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Group Pickerview
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
        view.addSubview(groupPickerView)
        groupPickerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(phoneTextField).offset(50)
            make.width.equalTo(phoneTextField)
            make.height.equalTo(phoneTextField)
        }
        
        groupPickerView.backgroundColor = UIColor.white
        
        // Add button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(500)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(0.5)
            make.height.equalTo(nameTextField.snp.height).multipliedBy(0.5)
        }
        
        addButton.setTitleColor(Colors.cardlyGrey, for: UIControlState.normal)
        addButton.backgroundColor = UIColor.clear
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        // Import contacts button
        view.addSubview(importContactsButton)
        importContactsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(200)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(1.5)
            make.height.equalTo(addButton.snp.height)
        }
        importContactsButton.setTitleColor(Colors.cardlyGrey, for: UIControlState.normal)
        importContactsButton.backgroundColor = UIColor.clear
        importContactsButton.setTitle("Import from Contacts", for: .normal)
        importContactsButton.addTarget(self, action: #selector(self.importContactButtonTapped), for: .touchUpInside)
        
    }
    
}

// MARK: - UIPickerView data source / delegate

extension AddContactViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
}

extension AddContactViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.groupSelected = groups[row]
        print(groupSelected)
    }
}

