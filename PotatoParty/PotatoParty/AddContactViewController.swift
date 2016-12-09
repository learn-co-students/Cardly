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
    let transparentCenterSubview = UIView()
    let backgroundPlaneImage = UIImageView(image: #imageLiteral(resourceName: "backgroundPaperAirplane"))

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        layoutElements()
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        nameTextField.delegate = self
        addButton.isEnabled = false
        print("Group selected: \(groupSelected)")
        
        
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
        authorizeAddressBook { (accessGranted) in
            print(accessGranted)
        }
        self.pickAContact()
        print ("import Contact Button Tapped")
    }
    
    // Accessing and Importing Selected Contact from User's Contact book
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        for contact in contacts {
            
            guard let firstAddress = contact.emailAddresses.first else { return }
            let emailAddress = String(firstAddress.value)
            print("emailAddress: \(emailAddress)")
            
            guard let firstPhoneNumber = contact.phoneNumbers.first else { return }
            let phoneNumber = String(describing: firstPhoneNumber.value.stringValue)
            print("phoneNumber: \(phoneNumber)")
            
            let firstName = contact.givenName
            let lastName = contact.familyName
            let fullName = ("\(firstName) \(lastName)")
            
            let appContact = Contact(fullName: fullName, email: emailAddress, phone: phoneNumber, image: nil)
            
            print(appContact.fullName, appContact.email, appContact.phone)
            
            let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
            let userContactsRef = contactsRef.child("\(uid)/all/")
            let contactItemRef = userContactsRef.childByAutoId()
            contactItemRef.setValue(appContact.toAny())
            
            let groupsRef = FIRDatabase.database().reference(withPath: "groups")
            let groupsUserRef = groupsRef.child("\(uid)/all/")
            let groupItemRef = groupsUserRef.child(contactItemRef.key)
            groupItemRef.setValue(appContact.toAny())
            
            
        }
        let destVC = ContactsViewController()
        navigationController?.pushViewController(destVC, animated: true)
        
        CustomNotification.show("Contacts were imported successfully")
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
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
    
    func pickAContact(){
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(format: "(phoneNumbers.@count > 0) && (emailAddresses.@count > 0)", argumentArray: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    
    func addButtonTapped() {
        
        //        let validPhone = validate(phoneTextField: phoneTextField)
        //        let validName = validate(nameTextField: nameTextField)
        //        let validEmail = validate(emailTextField: emailTextField)
        guard validCheck() else { return }
        
        guard let email = emailTextField.text, let name = nameTextField.text, let phone = phoneTextField.text else { return }
        //        let contact = Contact(fullName: name, email: email, phone: phone)
        let contact = Contact(fullName: name, email: email, phone: phone, group_key: groupSelected)
        
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
        let groupsUserRef = groupsRef.child("\(uid)/all/\(contactItemRef.key)")
        groupsUserRef.setValue(contact.toAny())
        
        if groupSelected != "All" {
            let path = "\(uid)/\(groupSelected.lowercased())/\(contactItemRef.key)/"
            let groupContactsRef = groupsRef.child(path)
            groupContactsRef.setValue(contact.toAny())
            
        }
        CustomNotification.show("Added successfully")
    }
    
    //Validating Fields
    
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
        addButton.backgroundColor = UIColor.white 
    }
    
    func shake(textfield: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        textfield.layer.add(animation, forKey: "shake")
        
    }

}
