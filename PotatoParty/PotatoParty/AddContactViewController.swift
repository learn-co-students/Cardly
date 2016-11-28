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
    let uid = User.shared.uid
    let groups = User.shared.groups
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var addButton = UIButton()
    var groupPickerView = UIPickerView()
    var importContactsButton = UIButton()
    var cancelButton = UIButton()
    let namePlaceholder = "Name"
    let emailPlaceholder = "example@serviceprovider"
    
    var dataDict = [String: String] ()
    
    var groupSelected: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        print("Group selected: \(groupSelected)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancelButtonTapped () {
        dismiss(animated: true, completion: nil)
    }

    func importContactButtonTapped () {
        print ("import Contact Button Tapped")
    }

    func addButtonTapped () {
        guard let email = emailTextField.text, let name = nameTextField.text else { return }
        let contact = Contact(fullName: name, email: email, phone: "7322225678")

        // Add to contacts bucket
        let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
        let userContactsRef = contactsRef.child("\(uid)/all/")
        let contactItemRef = userContactsRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
        
        if groupSelected != "All" {
            let path = "\(uid)/\(groupSelected.lowercased())/\(contactItemRef.key)/"
            let groupContactsRef = contactsRef.child(path)
            groupContactsRef.setValue(contact.toAny())
        }
        
        // Add to groups bucket
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let groupsUserRef = groupsRef.child("\(uid)/all/")
        groupsUserRef.setValue(contact.toAny())
        
        if groupSelected != "All" {
            let path = "\(uid)/\(groupSelected.lowercased())/\(contactItemRef.key)/"
            let groupContactsRef = groupsRef.child(path)
            groupContactsRef.setValue(contact.toAny())
        }
        
        nameTextField.text = namePlaceholder
        emailTextField.text = emailPlaceholder
    }
    
}
