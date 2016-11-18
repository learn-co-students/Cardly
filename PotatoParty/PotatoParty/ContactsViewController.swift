//
//  ContactsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit

class ContactsViewController: UIViewController {
    var bottomNavBar = BottomNavBarView()
    var collectionView = ContactsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ContactsViewController {
    // Setup all
    func setupViews() {
        setupCollectionView()
        setupTopNavBarView()
        setupBottomNavBarView()
    }
    
    // Setup individual view
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.875)
        }
    }
    
    func setupBottomNavBarView() {
        self.view.addSubview(bottomNavBar)
        bottomNavBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    func setupTopNavBarView() {
        // Do this
    }
    
}
