//
//  CardlyTextField.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 12/8/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit

struct CustomTextField {
    
    static func initTextField(placeHolderText: String, isSecureEntry: Bool) -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.layer.borderColor = Colors.cardlyGold.cgColor
        textField.layer.cornerRadius = Styles.cornerRadius
        textField.layer.borderWidth = 1
        textField.placeholder = placeHolderText
        textField.textAlignment = .center
        textField.alpha = 0.6
        if isSecureEntry {
            textField.isSecureTextEntry = true
        }
        return textField
    }
    
}
