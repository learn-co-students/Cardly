//
//  AddContactViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddContactViewController: UIViewController {

    let contactRef = FIRDatabase.database().reference(withPath: "contacts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(fullName: "Forrest Zhao", email: "forrest@gmail.com", phone: "8582231234")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addContact(fullName: String, email: String, phone: String) {
        let contact = Contact(fullName: fullName, email: email, phone: phone)
        let contactItemRef = contactRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
    }

}
