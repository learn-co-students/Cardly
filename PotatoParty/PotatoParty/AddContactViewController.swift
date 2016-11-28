//
//  AddContactViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Contacts
import ContactsUI

class AddContactViewController: UIViewController, CNContactViewControllerDelegate, CNContactPickerDelegate  {
    let uid = User.shared.uid
    let groups = User.shared.groups
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var phoneTextField = UITextField()
    var addButton = UIButton()
    var groupPickerView = UIPickerView()
    var importContactsButton = UIButton()
    var cancelButton = UIButton()
    
    var contactStore = CNContactStore()
    
    var dataDict = [String: String] ()
    
    var groupSelected: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        print("Group selected: \(groupSelected)")
        authorizeAddressBook { (accessGranted) in
            print(accessGranted)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func cancelButtonTapped () {
        dismiss(animated: true, completion: nil)
    }

    func importContactButtonTapped () {
        
      let contactPicker = CNContactViewController()
//        let contactsNavigationController = UINavigationController(rootViewController: contactPicker)
        contactPicker.delegate = self
//        contactsNavigationController.pushViewController(self, animated: true)
        self.present(contactPicker, animated: false, completion: nil)
    
    
        print ("import Contact Button Tapped")
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { (contact) in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value as! CNPhoneNumber
                print("number is = \(phoneNumber)")
            }
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    func addButtonTapped () {
        guard let email = emailTextField.text, let name = nameTextField.text, let phone = phoneTextField.text else { return }
        let contact = Contact(fullName: name, email: email, phone: phone)

        // Add to contacts bucket
        let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
        let userContactsRef = contactsRef.child("\(uid)/all/")
        let contactItemRef = userContactsRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
        
        nameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""
        nameTextField.placeholder = "Name"
        emailTextField.placeholder = "example@serviceprovider"
        phoneTextField.placeholder = "2224446666"
        
        
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

    }
    
    // import from address book - helper methods
    
    func authorizeAddressBook(completion: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

    switch authorizationStatus {
    case .authorized:
        completion(true)
    case .denied, .notDetermined:
        self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
            if access {
                completion(access)
            } else {
                print("access to use address book denied")
                }
            })
    default:
        completion(true)
        
        }
    
    }

}
