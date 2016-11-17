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

    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var addButton = UIButton()
    var groupDropDown = UIPickerView()
    var importContactsButton = UIButton()
    var cancelButton = UIButton()
    let namePlaceholder = "Name"
    let emailPlaceholder = "example@serviceprovider"
    
    let contactRef = FIRDatabase.database().reference(withPath: "contacts")

    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(fullName: "Forrest Zhao", email: "forrest@gmail.com", phone: "8582231234")
        layoutElements()
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

    func cancelButtonTapped () {
        dismiss(animated: true, completion: nil)
    }

    func importContactButtonTapped () {
        print ("import Contact Button Tapped")
    }

    func addButtonTapped () {
        guard let email = emailTextField.text, let name = nameTextField.text else { return }
        let contact = Contact(fullName: name, email: email, phone: "7322225678")
        let contactItemRef = contactRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
        
        nameTextField.text = namePlaceholder
        emailTextField.text = emailPlaceholder
        
        print ("add Button tapped")
    }

}
