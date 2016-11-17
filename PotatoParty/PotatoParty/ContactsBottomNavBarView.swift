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

// MARK: - Bottom Nav Bar

class ContactsBottomNavBarView: UIView {
    
    // Views
    var leftIconView = BottomNavBarLeftView()
    var middleIconView = BottomNavBarMiddleView()
    var rightIconView = BottomNavBarRightView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        print("frame init called")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("decoder init called")
    }
    
}

// MARK: - Nav Bar Individual Views

class BottomNavBarLeftView: UIView {
    var addContactBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Add button
        addContactBtn.setTitle("+", for: .normal)
        addContactBtn.setTitleColor(UIColor.black, for: .normal)
        addContactBtn.frame = CGRect()
        addSubview(addContactBtn)
        addContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        // Change background
        self.backgroundColor = UIColor.green
    }
}

class BottomNavBarMiddleView: UIView {
    
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

class BottomNavBarRightView: UIView {
    var sendToContactBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Add button
        self.addSubview(sendToContactBtn)
        sendToContactBtn.setTitle("Send", for: .normal)
        sendToContactBtn.setTitleColor(UIColor.black, for: .normal)
        sendToContactBtn.frame = CGRect()
        sendToContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.backgroundColor = UIColor.red
    }
    
}


// MARK: - Extensions

extension ContactsBottomNavBarView {
    
    func setupView() {
        // Create stack view
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(leftIconView)
        stackView.addArrangedSubview(middleIconView)
        stackView.addArrangedSubview(rightIconView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Create background
        self.backgroundColor = UIColor.black
    }
    
}
