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
        
        
        //view background
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
        
        // Name Textfield
        nameTextField = CustomTextField.initTextField(placeHolderText: "Contact Name", isSecureEntry: false)
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(view.frame.height/4)
            make.width.equalToSuperview().multipliedBy(0.60)
            make.height.equalTo(nameTextField.snp.width).multipliedBy(0.15)
        }
        
        
        // E-Mail Textfield
        emailTextField = CustomTextField.initTextField(placeHolderText: "Contact Email", isSecureEntry: false)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(nameTextField.snp.bottomMargin).offset(40)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Add Phone Number Textfield
        phoneTextField = CustomTextField.initTextField(placeHolderText: "Contact Phone Number", isSecureEntry: false)
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField.snp.bottomMargin).offset(40)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Group Pickerview
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
        view.addSubview(groupPickerView)
        groupPickerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(phoneTextField.snp.bottomMargin).offset(40)
            make.width.equalTo(phoneTextField)
            make.height.equalTo(phoneTextField)
        }
        
        groupPickerView.backgroundColor = UIColor.white
        
        // Add button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(groupPickerView.snp.bottomMargin).offset(40)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(0.5)
            make.height.equalTo(nameTextField.snp.height).multipliedBy(0.5)
        }
        
        addButton.backgroundColor = UIColor.clear
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        // Import contacts button
        view.addSubview(importContactsButton)
        importContactsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(addButton).offset(120)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(1.5)
            make.height.equalTo(addButton.snp.height)
        }
        
        importContactsButton.backgroundColor = UIColor.clear
        importContactsButton.setTitle("Import from Contacts", for: .normal)
        importContactsButton.addTarget(self, action: #selector(self.importContactButtonTapped), for: .touchUpInside)
        
        // Cancel button
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(importContactsButton).offset(40)
            make.width.equalTo(addButton.snp.width)
            make.height.equalTo(addButton.snp.height)
        }
        
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
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

