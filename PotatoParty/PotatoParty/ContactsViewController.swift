//
//  ContactsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class ContactsViewController: UIViewController {
    
    var contactsVCView: ContactsVCView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("STUFF")
      setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupViews() {
        
        let bottomView = BottomView(frame: CGRect(x: 0, y: 0, width: 374, height: 100))
        bottomView.displayType = .contacts
        
        
        
        self.view.addSubview(bottomView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
//        self.contactsVCView.snp.makeConstraints { (make) in
//            make.size.equalToSuperview()
//        }
        
    }
}
