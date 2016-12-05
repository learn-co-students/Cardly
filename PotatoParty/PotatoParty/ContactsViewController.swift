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


class ContactsViewController: UIViewController, DropDownMenuDelegate, AddContactsDelegate  {
    
    // Current user
    var shared = User.shared
    let uid = User.shared.uid
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    
    // UI
    var collectionView: ContactsCollectionView!
    var bottomNavBar: BottomNavBarView!
    var navigationBarMenu: DropDownMenu!
    var titleView: DropDownTitleView!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.contactDelegate = self
        self.restorationIdentifier = "contactsVC"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        retrieveContacts(for: User.shared.groups[0], completion: { contacts in
            self.collectionView.contacts = contacts
            self.collectionView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarMenu.container = view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - Views

extension ContactsViewController {
    
    // Setup all views
    func setupViews() {
        setupCollectionView()
        setupBottomNavBarView()
        setupTopNavBarView()
    }
    
    // Setup collection view
    func setupCollectionView() {
        collectionView = ContactsCollectionView(frame: self.view.frame)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    // Setup bottom nav bar
    func setupBottomNavBarView() {
        bottomNavBar = BottomNavBarView()
        bottomNavBar.leftIconView.delegate = self
        bottomNavBar.rightIconView.delegate = self
        self.view.addSubview(bottomNavBar)
        bottomNavBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
    }
    
    // Setup top nav bar
    func setupTopNavBarView() {
        self.navigationBarMenu = DropDownMenu()
        
        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        
        let rightBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.selectBtnClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let btnName = UIButton()
        btnName.setTitle("Settings", for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btnName.addTarget(self, action: #selector(self.navToSettingsVC), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
}

// MARK: - Top Navigation Bar Methods

extension ContactsViewController {
    
    func prepareNavigationBarMenuTitleView() -> String {
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        titleView.addTarget(self, action: #selector(self.willToggleNavigationBarMenu(_:)), for: .touchUpInside)
        titleView.addTarget(self, action: #selector(self.didToggleNavigationBarMenu(_:)), for: .valueChanged)
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "Lists"

        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    func showToolbarMenu() {
        if titleView.isUp {
            titleView.toggleMenu()
        }
        navigationBarMenu.show()
    }
    
    func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        navigationBarMenu.hide()
        
        if sender.isUp {
            navigationBarMenu.hide()
        }
        else {
            navigationBarMenu.show()
        }
    }
    
    func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        print("Sent did toggle navigation bar menu action")
    }
    
    func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        if menu == navigationBarMenu {
            titleView.toggleMenu()
        }
        else {
            menu.hide()
        }
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
        navigationBarMenu.visibleContentOffset = navigationController!.navigationBar.frame.size.height + 24
        
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    func selectGroup(_ sender: UITableViewCell) {
        guard let group = sender.textLabel?.text?.lowercased() else { return }
        self.retrieveContacts(for: group, completion: { contacts in
            self.collectionView.contacts = contacts
            self.collectionView.reloadData()
        })
        navigationBarMenu.hide()
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
        let destVC = ContactsViewController()
        navigationController?.pushViewController(destVC, animated: false)
    }

    func goToAddContact(){
        let destVC = AddContactViewController()
        navigationController?.pushViewController(destVC, animated: false)
    }
    
    func deleteButtonPressed() {
        deleteContacts {
            retrieveContacts(for: User.shared.groups[0], completion: { contacts in
                self.collectionView.contacts = contacts
                self.collectionView.reloadData()
            })
            collectionView.reloadData()
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
    
    func removeFromAllGroupsinFB(contact: Contact) {
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
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = true //allow video editing
        cameraController.cameraCaptureMode = .video
        cameraController.delegate = delegate
        cameraController.videoQuality = .typeHigh
        cameraController.videoMaximumDuration = 20.0
        
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
        print("In did finish picking media")
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


protocol AddContactsDelegate: class {
   func goToAddContact()
}
