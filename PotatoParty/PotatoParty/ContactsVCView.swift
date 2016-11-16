//
//  ContactsVCView.swift
//  PotatoParty
//
//  Created by Michelle Staton on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsVCView: UIView {
    
    var topNavBarView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupTopNavbarView()

        
    }
    
    func setupTopNavbarView() {
        self.topNavBarView = UIView() 
        self.addSubview(topNavBarView)
        topNavBarView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(100) // possibly change
            make.top.equalToSuperview()
            // possibly make the bottom equal to the top of the view underneith it
            
        }
        topNavBarView.backgroundColor = UIColor.blue
    }
    
    
}

