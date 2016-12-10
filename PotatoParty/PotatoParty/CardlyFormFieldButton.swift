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
        button.setTitle(title, for: .normal)
        button.titleLabel!.font = UIFont(name: Font.regular, size: Font.Size.l)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(Colors.cardlyGold, for: .highlighted)
        button.titleLabel!.minimumScaleFactor = 0.5
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.sizeToFit()
        return button
    }
    
}
