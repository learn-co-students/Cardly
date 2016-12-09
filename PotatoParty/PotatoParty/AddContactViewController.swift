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
        self.navigationController?.isNavigationBarHidden = true
        
        layoutElements()
        
        emailTextField.delegate = self
        phoneTextField.delegate = self
        nameTextField.delegate = self
        addButton.isEnabled = false
        print("Group selected: \(groupSelected)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

// MARK: - Firebase methods
    
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
    
// MARK: - Button methods
    
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
    
    func importContactButtonTapped () {
        authorizeAddressBook { (accessGranted) in
            print(accessGranted)
        }
        self.pickAContact()
        print ("import Contact Button Tapped")
    }
    
    
    func dismissButtonTapped(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
// MARK: - Form field validation methods
    
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

extension AddContactViewController {
    
    func layoutElements() {
        
        backButton = UIButton()
        view.addSubview(backButton)
        backButton.setImage(Icons.backButton, for: .normal)
        backButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        backButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.topMargin.equalToSuperview().offset(40)
            make.leadingMargin.equalToSuperview()
        }
        
        view.backgroundColor = Colors.cardlyBlue
        
        view.addSubview(backgroundPlaneImage)
        backgroundPlaneImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(transparentCenterSubview)
        transparentCenterSubview.backgroundColor = UIColor(white: 1, alpha: 0.5)
        transparentCenterSubview.layer.borderColor = Colors.cardlyGold.cgColor
        transparentCenterSubview.layer.borderWidth = 1.0
        transparentCenterSubview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "Add Contacts"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = UIFont(name: Font.fancy, size: Font.Size.viewTitle)
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 3
        titleLabel.layer.shadowOpacity = 1
        titleLabel.sizeToFit()
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(backButton).offset(45)
        }
        
        nameTextField = CustomTextField.initTextField(placeHolderText: "Contact Name", isSecureEntry: false)
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(275)
            make.width.equalToSuperview().multipliedBy(0.60)
            make.height.equalTo(nameTextField.snp.width).multipliedBy(0.15)
        }
        
        
        // E-Mail Textfield
        emailTextField = CustomTextField.initTextField(placeHolderText: "Contact Email", isSecureEntry: false)
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(nameTextField).offset(45)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Add Phone Number Textfield
        phoneTextField = CustomTextField.initTextField(placeHolderText: "Contact Phone Number", isSecureEntry: false)
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(emailTextField).offset(45)
            make.width.equalTo(nameTextField)
            make.height.equalTo(nameTextField)
        }
        
        
        // Group Pickerview
        groupPickerView.dataSource = self
        groupPickerView.delegate = self
        view.addSubview(groupPickerView)
        groupPickerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(phoneTextField).offset(50)
            make.width.equalTo(phoneTextField)
            make.height.equalTo(phoneTextField)
        }
        
        groupPickerView.backgroundColor = UIColor.white
        
        // Add button
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(500)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(0.5)
            make.height.equalTo(nameTextField.snp.height).multipliedBy(0.5)
        }
        
        addButton.setTitleColor(Colors.cardlyGrey, for: UIControlState.normal)
        addButton.backgroundColor = UIColor.clear
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        // Import contacts button
        view.addSubview(importContactsButton)
        importContactsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(200)
            make.width.equalTo(nameTextField.snp.width).multipliedBy(1.5)
            make.height.equalTo(addButton.snp.height)
        }
        importContactsButton.setTitleColor(Colors.cardlyGrey, for: UIControlState.normal)
        importContactsButton.backgroundColor = UIColor.clear
        importContactsButton.setTitle("Import from Contacts", for: .normal)
        importContactsButton.addTarget(self, action: #selector(self.importContactButtonTapped), for: .touchUpInside)
        
    }
    
}

// MARK: - UIPickerView data source / delegate

extension AddContactViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickAContact(){
        let controller = CNContactPickerViewController()
        controller.delegate = self
        controller.predicateForEnablingContact = NSPredicate(format: "(phoneNumbers.@count > 0) && (emailAddresses.@count > 0)", argumentArray: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
}

extension AddContactViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.groupSelected = groups[row]
        print(groupSelected)
    }
}

