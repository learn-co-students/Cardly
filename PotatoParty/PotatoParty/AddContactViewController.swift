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
import Whisper

class AddContactViewController: UIViewController, CNContactViewControllerDelegate, CNContactPickerDelegate, UITextFieldDelegate, UICollectionViewDelegate  {
    let uid = User.shared.uid
    let groups = User.shared.groups
    var backButton: UIButton!
    var dismissButton: UIButton?
    
    var nameTextField = UITextField()
    var emailTextField = UITextField()
    var phoneTextField = UITextField()
    var addButton = UIButton()
    var groupPickerView = UIPickerView()
    var importContactsButton = UIButton()

    var contactStore = CNContactStore()
    var dataDict = [String: String] ()
    var groupSelected: String = "All"
    let transparentCenterSubview = UIView()
    let backgroundPlaneImage = UIImageView(image: #imageLiteral(resourceName: "backgroundPaperAirplane"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        layoutElements()
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        nameTextField.delegate = self
        addButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func importContactButtonTapped () {
        authorizeAddressBook { (accessGranted) in
            print(accessGranted)
        }
        self.pickAContact()
    }
    
    
    func dismissButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        _ = self.navigationController?.isNavigationBarHidden = false
    }
    
    // Accessing and Importing Selected Contact from user's Contact Book
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // Count accounts for the default contact ('Add Contact' button) which is always the first item in contacts array
        var count = contacts.count - 1
        
        for contact in contacts {
            // Firebase URL
            let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
            let userContactsRef = contactsRef.child("\(uid)/all/")
            let contactItemRef = userContactsRef.childByAutoId()

            // Dissemble Apple CNContact class and convert to custom Contact class
            guard let firstAddress = contact.emailAddresses.first else { return }
            let emailAddress = String(firstAddress.value)
            
            guard let firstPhoneNumber = contact.phoneNumbers.first else { return }
            let phoneNumber = String(describing: firstPhoneNumber.value.stringValue)
            
            let firstName = contact.givenName
            let lastName = contact.familyName
            let fullName = ("\(firstName) \(lastName)")
            
            // Instantiate custom Contact class
            let appContact = Contact(fullName: fullName, email: emailAddress, phone: phoneNumber)
            
            // Add key to custom Contact and append to contacts
            appContact.key = contactItemRef.key
            User.shared.contacts.append(appContact)
            
            // Firebase methods
            contactItemRef.setValue(appContact.toAny(), withCompletionBlock: { error, ref in
                
                let groupsRef = FIRDatabase.database().reference(withPath: "groups")
                let groupsUserRef = groupsRef.child("\(self.uid)/all/")
                let groupItemRef = groupsUserRef.child(contactItemRef.key)
                
                groupItemRef.setValue(appContact.toAny(), withCompletionBlock: { [unowned self] error, ref in
                    
                    count -= 1
                    if count <= 0 {
                        CustomNotification.show("Contacts were imported successfully")
                        self.navigationController?.isNavigationBarHidden = false
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    }
    
    // Import from address book - helper methods
    
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
    
    func pickAContact(){
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(format: "(phoneNumbers.@count > 0) && (emailAddresses.@count > 0)", argumentArray: nil)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func addButtonTapped() {
        guard validCheck() else { return }
        
        guard let email = emailTextField.text, let name = nameTextField.text, let phone = phoneTextField.text else { return }
        let contact = Contact(fullName: name, email: email, phone: phone, group_key: groupSelected)
        
        // Add to contacts bucket
        let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
        let userContactsRef = contactsRef.child("\(uid)/all/")
        let contactItemRef = userContactsRef.childByAutoId()
        contactItemRef.setValue(contact.toAny())
        
        nameTextField.text = ""
        emailTextField.text = ""
        phoneTextField.text = ""

        if groupSelected != "All" {
            let path = "\(uid)/\(groupSelected.lowercased())/\(contactItemRef.key)/"
            let groupContactsRef = contactsRef.child(path)
            groupContactsRef.setValue(contact.toAny())
            
        }
        
        // Add to groups bucket
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let groupsUserRef = groupsRef.child("\(uid)/all/\(contactItemRef.key)")
        groupsUserRef.setValue(contact.toAny())
        
        if groupSelected != "All" {
            let path = "\(uid)/\(groupSelected.lowercased())/\(contactItemRef.key)/"
            let groupContactsRef = groupsRef.child(path)
            groupContactsRef.setValue(contact.toAny())
            
        }
        CustomNotification.show("Added successfully")
    }
    
    // Validating Fields
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePhone(phone: String) -> Bool {
        let characterArray = [Character](phone.characters)
        return characterArray.count == 10
    }
    
    func validateName(name: String) -> Bool {
        return name.characters.count >= 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case phoneTextField:
            if validatePhone(phone: phoneTextField.text!){
                if validCheck() {
                    enableAddButton()
                }
                print("valid phone")
            } else {
                print("not valid phone")
                shake(textfield: phoneTextField)
            }
        case emailTextField:
            if validateEmail(email: emailTextField.text!) {
                print("Valid Email")
                if validCheck() {
                    enableAddButton()
                }
            } else {
                shake(textfield: emailTextField)
                print ("non valid email")
            }
        case nameTextField:
            if validateName(name: nameTextField.text!){
                if validCheck() {
                    enableAddButton()
                }
                print("valid name")
            } else {
                shake(textfield: nameTextField)
                print("enter your name")
            }
        default:
            return
        }
        
    }
    
    func validCheck() -> Bool {
        return validateName(name: nameTextField.text!) && validatePhone(phone: phoneTextField.text!) && validateEmail(email: emailTextField.text!)
        
    }
    func enableAddButton() {
        addButton.isEnabled = true
        addButton.backgroundColor = UIColor.gray
    }
    
    func shake(textfield: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        textfield.layer.add(animation, forKey: "shake")
        
    }

}
