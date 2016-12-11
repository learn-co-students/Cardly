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
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.textAlignment = .center
        textField.alpha = 0.6
        if isSecureEntry {
            textField.isSecureTextEntry = true
        }
        return textField
    }
    
    static func shake(textfield: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        textfield.layer.add(animation, forKey: "shake")
    }
    
}
