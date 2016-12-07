//
//  Constants.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit

struct Styles {
    static let cornerRadius: CGFloat = 7
}

struct Font {
    static let name = "Helvetica Neue UltraLight"
    static let nameForCard = "Qwigley-Regular"
    
    struct Size {
        static let xs: CGFloat = 8
        static let s: CGFloat = 12
        static let m: CGFloat = 18
        static let l: CGFloat = 24
        static let xl: CGFloat = 36
        static let xxl: CGFloat = 48
        static let cardView: CGFloat = 64
        static let cardVideo: CGFloat = 120
    }
    
}

struct Colors {
    static let cardlyBlue = UIColor(red:0.44, green:0.89, blue:0.89, alpha:1.0)
    static let cardlyGold = UIColor(red:0.92, green:0.87, blue:0.71, alpha:1.0)
    static let cardlyGrey = UIColor(white:0.29, alpha:1.0)
}
