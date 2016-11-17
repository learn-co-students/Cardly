//
//  ContactsViewControllerExtension.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension ContactsViewController {
    
    // Setup all
    func setupViews() {
        setupBottomNavBarView()
    }
    
    func setupBottomNavBarView() {
        self.view.addSubview(bottomNavBar)
        
        bottomNavBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        // Do this
    }
    
    func setupTopNavBarView() {
        // Do this
    }
    
}
