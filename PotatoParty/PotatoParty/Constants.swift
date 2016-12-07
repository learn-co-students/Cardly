//
//  Constants.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import Whisper

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
    static let orange = UIColor(red: 225.0/255.0, green: 50.0/255.0, blue: 29.0/255.0, alpha: 1)
    
}

struct CustomNotification {
     static func show(_ notification: String) {
        var murmur = Murmur(title: notification)
        
        murmur.titleColor = UIColor.black
        murmur.backgroundColor = UIColor.cyan
        
        let whistleAction = WhistleAction.show(2.0)
        
        Whisper.show(whistle: murmur, action: whistleAction)
    }
    
    static func showError(_ notification: String) {
        var murmur = Murmur(title: notification)
        
        murmur.titleColor = UIColor.black
        murmur.backgroundColor = UIColor.red
        
        let whistleAction = WhistleAction.show(2.0)
        
        Whisper.show(whistle: murmur, action: whistleAction)
        
    }
}

struct SettingsErrorMessage {
    static var authFailed = "User authentication failed. Please make sure password is correct"
    static var passwordEmpty = "Current password cannot be empty"
    static var confirmPasswordEmpty = "Confirm password cannot be empty"
    static var newPasswordEmpty = "New password cannot be empty"
    static var confirmPasswordMatch = "New and confirm passwords do not match"
    static var passwordLength = "Password length must at least 6 character"
    static var passwordUpdate = "Failed to change password"
    static var emailEmpty = "Email cannot be empty"
    static var emailFormat = "Email format must be xxx@xxx.xxx"
    static var emailAlreadyInUse = "Email is already in use"
    static var invalidEmail = "Email is invalid"
    static var generalEmail = "Error changing email"
    static var changeEmailFieldsNotCorrect = "Please make sure password and email fields are valid"
    static var changePasswordFieldsNotCorrect = "Please make sure all password fields are valid"
}

struct SettingsSuccessMessage {
    static var passwordChanged = "Password successfully changed"
    static var emailChanged = "Email successfully changed"
}
