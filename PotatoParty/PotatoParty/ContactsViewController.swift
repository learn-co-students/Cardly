//
//  ContactsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase
import FirebaseAuth


class ContactsViewController: UIViewController {
    // Views
    var bottomNavBar = BottomNavBarView()
    var collectionView = ContactsCollectionView()
    
    // Firebase
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    var user: User?
    var userUid: String?
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup views
        setupViews()
        
        // Firebase methods
        self.restorationIdentifier = "contactsVC"
        navigationController?.navigationBar.isHidden = true
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.userUid = user.uid
            print("Current logged in user email - \(self.user?.email)")
        })
        
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    self.contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
                print("Current contacts list contains:")
                dump(self.contacts)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ContactsViewController {
    // Setup all views
    func setupViews() {
        setupCollectionView()
        setupTopNavBarView()
        setupBottomNavBarView()
    }
    
    // Setup individual views
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
