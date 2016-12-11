//
//  CardlyFormFieldButton.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 12/8/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit

struct CardlyFormFieldButton {
    
    static func initButton(title: String, target: Any?, selector: Selector) -> UIButton {
        let button = UIButton()
        let rect = CGRect(x: 0, y: 0, width: 1, height: 35)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.gray.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        button.setTitle(" \(title) ", for: .normal)
        button.titleLabel!.font = UIFont(name: Font.regular, size: Font.Size.m)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(Colors.cardlyGold, for: .highlighted)
        button.setBackgroundImage(image, for: .highlighted)
        button.titleLabel!.minimumScaleFactor = 0.5
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = Styles.cornerRadius
        button.layer.borderWidth = 1.5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.sizeToFit()
        return button
    }
    
}
