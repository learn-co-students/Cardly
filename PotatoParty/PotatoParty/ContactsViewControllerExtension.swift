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
    
    func setupViews() {
        self.view.addSubview(bottomNavBar)
        
        bottomNavBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(150)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
