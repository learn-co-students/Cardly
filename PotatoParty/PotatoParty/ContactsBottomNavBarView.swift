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
        
        addContactBtn.setTitle("+", for: .normal)
        addContactBtn.setTitleColor(UIColor.black, for: .normal)
        addContactBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 70)
        addSubview(addContactBtn)
        addContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
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



extension ContactsBottomNavBarView {
    func setupView() {
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
        
        self.backgroundColor = UIColor.black
    }
    
}
