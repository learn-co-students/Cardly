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
import SnapKit
import MobileCoreServices

protocol AddContactsDelegate: class {
    func goToAddContact()
}

class ContactsViewController: UIViewController, DropDownMenuDelegate, AddContactsDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Current user
    let shared = User.shared
    let currentUserUid = FIRAuth.auth()?.currentUser?.uid
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    
    // UI
    let backgroundImageView = UIImageView()
    var contactsCollectionView: ContactsCollectionView!
    var bottomNavBar: BottomNavBarView!
    var navSelecAllButton: UIBarButtonItem!
    var navigationBarMenu: DropDownMenu!
    var titleView: DropDownTitleView!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    var timer = Timer()
    var pickGroup = UIPickerView()
    var pickerData = ["All", "Family", "Friends", "Coworkers", "Other"]
    var chosenGroup = ""
    var allSelected: Bool = false
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // Default contact enables the first cell in the CollectvionView to be the 'Add Contact' button
    let defaultContact = Contact(fullName: "AddContact", email: "", phone: "")

    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        contactsCollectionView.delegate = self
        self.restorationIdentifier = "contactsVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        super.viewDidAppear(animated)
        navigationBarMenu.container = view
        contactsCollectionView.reloadData()
    }
    
}

// MARK: - Views

extension ContactsViewController {
    
    // Setup all views
    func setupViews() {
        view.backgroundColor = Colors.cardlyBlue
        setupCollectionView()
        setupBottomNavBarView()
        setupTopNavBarView()
    }
    
    // Setup collection view
    func setupCollectionView() {
        contactsCollectionView = ContactsCollectionView(frame: self.view.frame)
        self.view.addSubview(contactsCollectionView)
        contactsCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.90)
        }
    }
    
    // Setup bottom nav bar
    func setupBottomNavBarView() {
        bottomNavBar = BottomNavBarView()
        bottomNavBar.leftIconView.delegate = self
        bottomNavBar.rightIconView.delegate = self
        bottomNavBar.middleIconView.delegate = self
        self.view.addSubview(bottomNavBar)
        bottomNavBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(contactsCollectionView.snp.bottom)
        }
    }
    
    // Setup top nav bar
    func setupTopNavBarView() {
        self.navigationBarMenu = DropDownMenu()
        
        pickGroup.delegate = self
        pickGroup.dataSource = self
        
        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        
        // Select all contacts button (right)
        let rightBtn = UIButton()
        rightBtn.setImage(Icons.selectAllContactsButton, for: .normal)
        rightBtn.imageView!.snp.makeConstraints({ (make) in
            make.width.equalTo(rightBtn.snp.height)
            make.right.equalToSuperview()
        })
        rightBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        rightBtn.addTarget(self, action: #selector(selectBtnClicked), for: .touchUpInside)
        
        let rightBtnItem = UIBarButtonItem()
        rightBtnItem.customView = rightBtn
        self.navigationItem.rightBarButtonItem = rightBtnItem
        navSelecAllButton = rightBtnItem

        // Settings button (left)
        let btnName = UIButton()
        btnName.setImage(Icons.settingsButton, for: .normal)
        btnName.imageView?.snp.makeConstraints({ (make) in
            make.width.equalTo(btnName.snp.height)
            make.left.equalToSuperview()
        })
        btnName.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btnName.addTarget(self, action: #selector(self.navToSettingsVC), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
}

// MARK: - Top Navigation Bar Methods

extension ContactsViewController {
    
    func prepareNavigationBarMenuTitleView() -> String {
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))

        // Targets
        titleView.addTarget(self, action: #selector(self.willToggleNavigationBarMenu(_:)), for: .touchUpInside)
        titleView.addTarget(self, action: #selector(self.didToggleNavigationBarMenu(_:)), for: .valueChanged)

        // Title
        titleView.titleLabel.textColor = UIColor.blue
        titleView.titleLabel.font = UIFont(name: Font.regular, size: Font.Size.m)
        titleView.title = "Groups"
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        navigationBarMenu.delegate = self
        
        let arrayofWeddingLists = User.shared.groups
        
        var menuCellArray = [DropDownMenuCell]()
        for list in arrayofWeddingLists {
            let firstCell = DropDownMenuCell()
            firstCell.textLabel!.text = list
            
            firstCell.menuAction = #selector(selectGroup(_:))
            
            firstCell.menuTarget = self
            if currentChoice == list {
                firstCell.accessoryType = .checkmark
            }
            
            menuCellArray.append(firstCell)
        }
        
        navigationBarMenu.menuCells = menuCellArray
        navigationBarMenu.selectMenuCell(menuCellArray[0])
        navigationBarMenu.visibleContentOffset = navigationController!.navigationBar.frame.height + 24
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        if sender.isUp {
            navigationBarMenu.hide()
        }
        else {
            navigationBarMenu.show()
        }
    }
    
    // AlertConroller & UIPicker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("pickerView called")
        
        switch row {
        case 0:
            chosenGroup = "all"
            updateGroup {
                shared.selectedContacts.removeAll()
                contactsCollectionView.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
        case 1:
            chosenGroup = "family"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
        case 2:
            chosenGroup = "friends"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
        case 3:
            chosenGroup = "coworkers"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
        case 4:
            chosenGroup = "other"
            updateGroup {
                shared.selectedContacts.removeAll()
            }
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func showPickerInAlert() {
        let alert = UIAlertController(title: "Choose Group", message: "\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.view.addSubview(pickGroup)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Layout view elements

extension ContactsViewController {
    
    func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        
    }
    
    func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        if menu == navigationBarMenu {
            titleView.toggleMenu()
        } else {
            menu.hide()
        }
    }
    
    func selectGroup(_ sender: UITableViewCell) {
        
        // Retrieve from Firebase
        guard let group = sender.textLabel?.text?.lowercased() else { return }
        self.retrieveContacts(for: group, completion: { contacts in
            
            User.shared.contacts = contacts
            User.shared.contacts.insert(self.defaultContact, at: 0)
            
            // Empty selected contacts and hide edit+delete functionality
            self.shared.selectedContacts = []
            self.bottomNavBar.middleIconView.editGroupButton.isHidden = true
            self.bottomNavBar.leftIconView.deleteContactBtn.isHidden = true
            
            self.contactsCollectionView.reloadData()
        
        })
        
        // Hide Top Nav Bar after group is selected
        if self.navigationBarMenu.container != nil {
            self.titleView.toggleMenu()
        }
    }
}


// MARK: - Navigation methods (buttons)

extension ContactsViewController: BottomNavBarDelegate {
    
    func navToSettingsVC(_ sender: UIButton) {
        let destVC = SettingsViewController()
        
        destVC.modalPresentationStyle = .custom
        destVC.transitioningDelegate = self
        
        presentationAnimator.animationDuration = 0.2
        presentationAnimator.animationDelegate = destVC as? GuillotineAnimationDelegate
        presentationAnimator.presentButton = view
        present(destVC, animated: true, completion: nil)
    }
    
    func selectBtnClicked() {
        if allSelected == false {
            for (index, contact) in User.shared.contacts.enumerated() {
                if index > 0 {
                    contact.isChosen = true
                    User.shared.selectedContacts.append(contact)
                }
            }
            enableCell()
            contactsCollectionView.reloadData()
            allSelected = true
        } else {
            for (index, contact) in User.shared.contacts.enumerated() {
                if index > 0 {
                    contact.isChosen = false
                }
            }
            User.shared.selectedContacts.removeAll()
            enableCell()
            contactsCollectionView.reloadData()
            allSelected = false
        }
    }
    
    func goToAddContact(){
        // TODO: - New AddContact VC is being instantiated
        let destVC = AddContactViewController()
        navigationController?.pushViewController(destVC, animated: true)
        shared.selectedContacts.removeAll()
    }
    
    func deleteButtonPressed() {
        deleteContacts {
            retrieveContacts(for: User.shared.groups[0], completion: { contacts in
                User.shared.contacts = contacts

                
                User.shared.contacts.insert(self.defaultContact, at: 0)

                self.contactsCollectionView.reloadData()
            })
            enableCell()
           contactsCollectionView.reloadData()
        }
        
    }
    
    func editGroupButtonPressed(){
        showPickerInAlert()
    }
    
    
    // Updates Contact Group property and reloaded Collection View
    
    func updateGroup(completion: () -> ()) {
        guard let uid = currentUserUid else {
            print(UserError.NoCurrentUser)
            return
        }
        for (index, contact) in shared.selectedContacts.enumerated() {
            
            removeFromSomeGroupsinFB(contact: contact)
            
            shared.selectedContacts[index].group_key = chosenGroup
            
            // Update group bucket
            let groupsRef = FIRDatabase.database().reference(withPath: "groups")
            let allGroupPath = groupsRef.child("\(uid)/\(chosenGroup)")
            let groupItemRef = allGroupPath.child(contact.key)
            groupItemRef.setValue(contact.toAny())
            
            // Update contact group bucket
            let contactsPath = ref.child("\(uid)/\(chosenGroup)")
            let contactItemRef = contactsPath.child(contact.key)
            contactItemRef.setValue(contact.toAny())
            
        }
        
    }
    
    func sendToButtonPressed() {
        navToRecordCardVC()
    }
    
    func navToRecordCardVC() {
        let _ = startCameraFromViewController(self, withDelegate: self)
    }
    
}

// MARK: - Firebase methods

extension ContactsViewController {
    
    func retrieveContacts(for group: String, completion: @escaping (_: [Contact]) -> Void) {
        var contacts: [Contact] = []
        guard let uid = currentUserUid else {
            print(UserError.NoCurrentUser)
            return
        }
        let path = "\(uid)/\(group.lowercased())/"
        let contactBucketRef = ref.child(path)
        contactBucketRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
            }
            completion(contacts)
        })
    }
    
    func deleteContacts(completion: ()->()) {
        for contact in shared.selectedContacts{
            removeFromAllGroupsinFB(contact: contact)
            shared.selectedContacts.removeAll()
            shared.contacts.removeAll()
        }
        completion()
    }
    
    func removeFromSomeGroupsinFB(contact: Contact){
        guard let uid = currentUserUid else {
            print(UserError.NoCurrentUser)
            return
        }
        let familyPath = "\(uid)/family/\(contact.key)"
        let friendsPath = "\(uid)/friends/\(contact.key)"
        let coworkersPath = "\(uid)/coworkers/\(contact.key)"
        let otherPath = "\(uid)/other/\(contact.key)"
        
        ref.child(familyPath).removeValue()
        ref.child(friendsPath).removeValue()
        ref.child(coworkersPath).removeValue()
        ref.child(otherPath).removeValue()
        
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let familyGroupPath = "\(uid)/family/\(contact.key)"
        let friendsGroupPath = "\(uid)/friends/\(contact.key)"
        let coworkersGroupPath = "\(uid)/coworkers/\(contact.key)"
        let otherGroupPath = "\(uid)/other/\(contact.key)"
        
        groupsRef.child(familyGroupPath).removeValue()
        groupsRef.child(friendsGroupPath).removeValue()
        groupsRef.child(coworkersGroupPath).removeValue()
        groupsRef.child(otherGroupPath).removeValue()
    }
    
    func removeFromAllGroupsinFB(contact: Contact) {
        guard let uid = currentUserUid else {
            print(UserError.NoCurrentUser)
            return
        }
        let allPath = "\(uid)/all/\(contact.key)"
        let familyPath = "\(uid)/family/\(contact.key)"
        let friendsPath = "\(uid)/friends/\(contact.key)"
        let coworkersPath = "\(uid)/coworkers/\(contact.key)"
        let otherPath = "\(uid)/other/\(contact.key)"
        ref.child(allPath).removeValue()
        ref.child(familyPath).removeValue()
        ref.child(friendsPath).removeValue()
        ref.child(coworkersPath).removeValue()
        ref.child(otherPath).removeValue()
        
        let groupsRef = FIRDatabase.database().reference(withPath: "groups")
        let allGroupPath = "\(uid)/all/\(contact.key)"
        let familyGroupPath = "\(uid)/family/\(contact.key)"
        let friendsGroupPath = "\(uid)/friends/\(contact.key)"
        let coworkersGroupPath = "\(uid)/coworkers/\(contact.key)"
        let otherGroupPath = "\(uid)/other/\(contact.key)"
        groupsRef.child(allGroupPath).removeValue()
        groupsRef.child(familyGroupPath).removeValue()
        groupsRef.child(friendsGroupPath).removeValue()
        groupsRef.child(coworkersGroupPath).removeValue()
        groupsRef.child(otherGroupPath).removeValue()
        
    }
    
}


// MARK: - Show Camera VC
extension ContactsViewController {
    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.cameraDevice = .front
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = true //allow video editing
        cameraController.cameraCaptureMode = .video
        cameraController.delegate = delegate
        cameraController.videoMaximumDuration = 20.0
        cameraController.videoQuality = .typeIFrame1280x720
        
        let maxRecordTime = "Max Record Time is 20 sec"
        let maxTimeLabel = UILabel()
        maxTimeLabel.text = maxRecordTime
        maxTimeLabel.textAlignment = .center
        maxTimeLabel.textColor = UIColor.red
        cameraController.view.addSubview(maxTimeLabel)
        
        maxTimeLabel.snp.makeConstraints { (make) in
            make.topMargin.equalToSuperview().offset(50)
            make.leadingMargin.equalToSuperview().offset(-300)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
        
        present(cameraController, animated: true, completion: {
            cameraController.view.layoutIfNeeded()
            
            maxTimeLabel.snp.remakeConstraints({ (make) in
                make.topMargin.equalToSuperview().offset(50)
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(20)
            })
            
            cameraController.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
                print("In animation")
                cameraController.view.layoutIfNeeded()
            }, completion: { (complete) in
                UIView.animate(withDuration: 2, animations: {
                    maxTimeLabel.alpha = 0
                })
            })
        })
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ContactsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let unwrappedURL = info[UIImagePickerControllerMediaURL] as? URL else { return }
            
            // Pass video to edit video viewcontroller
            let editVideoVC = EditCardViewController()
            editVideoVC.fileLocation = unwrappedURL
            navigationController?.pushViewController(editVideoVC, animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension ContactsViewController: UINavigationControllerDelegate {
    
}


// MARK: - Animated Settings Button

extension ContactsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension ContactsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedContact = User.shared.contacts[indexPath.row]
        
        if indexPath.row == 0 {
            goToAddContact()
            
        } else {
            if selectedContact.isChosen == true {
                
                let selectedCell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
                selectedCell.handleTap()
                User.shared.contacts[indexPath.row].isChosen = false
                shared.selectedContacts = shared.selectedContacts.filter({ (contact) -> Bool in
                    return contact.email != User.shared.contacts[indexPath.row].email
                })
                enableCell()
            } else {
                shared.selectedContacts.append(selectedContact)
                let selectedCell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
                selectedCell.handleTap()
                User.shared.contacts[indexPath.row].isChosen = true
                enableCell()
            }
        }
    }
    
    func enableCell(){
        if shared.selectedContacts.isEmpty == false {
            bottomNavBar.leftIconView.deleteContactBtn.isEnabled = true
            bottomNavBar.leftIconView.deleteContactBtn.isHidden = false
            bottomNavBar.middleIconView.editGroupButton.isEnabled = true
            bottomNavBar.middleIconView.editGroupButton.isHidden = false
        } else {
            bottomNavBar.leftIconView.deleteContactBtn.isEnabled = false
            bottomNavBar.leftIconView.deleteContactBtn.isHidden = true
            bottomNavBar.middleIconView.editGroupButton.isEnabled = false
            bottomNavBar.middleIconView.editGroupButton.isHidden = true
        }
        
    }
    
}
