//
//  ContactsBottomNavBarView.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsBottomNavBar: UIView {
    
//    var leftIconView: BottomNavBarLeftIcon!
//    var middleIconView: BottomNavBarMiddleIcon!
//    var rightIconView: BottomNavBarRightIcon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        print("frame init called")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        print("decoder init called")
    }
    
}


/*
class BottomNavBarLeftIcon: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.green
    }
    
}

class BottomNavBarMiddleIcon: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.orange
    }
    
}

class BottomNavBarRightIcon: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.red
    }
    
}

*/


extension ContactsBottomNavBar {
    
    func setupView() {
        
//        let stackView = UIStackView()
//        self.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.addArrangedSubview(leftIconView)
//        stackView.addArrangedSubview(middleIconView)
//        stackView.addArrangedSubview(rightIconView)
        
        
        self.backgroundColor = UIColor.black
    }
    
}
