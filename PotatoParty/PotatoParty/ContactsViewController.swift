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

class ContactsViewController: UIViewController, DropDownMenuDelegate {
    
    // MARK: - Views
    var collectionView: ContactsCollectionView!
    var bottomNavBar: BottomNavBarView!
    var navigationBarMenu: DropDownMenu!
    var titleView: DropDownTitleView!
    
    let ref = FIRDatabase.database().reference(withPath: "contacts")
    let uid = User.shared.uid
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        // MARK: - Setup Views
        setupViews()
        
        self.restorationIdentifier = "contactsVC"
        
        self.navigationBarMenu = DropDownMenu()
        
        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        
        let rightBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.selectBtnClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
        // TO DO: Hook up the action
        
        let leftBtn = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.navToSettingsVC))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.retrieveContactsFromDB { (contactList) in
            self.collectionView.contacts = contactList
            self.collectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarMenu.container = view
    }
    
    // MARK: - Navigation Bar Dropdown
    
    func prepareNavigationBarMenuTitleView() -> String {
        // Both title label and image view are fixed horizontally inside title
        // view, UIKit is responsible to center title view in the navigation bar.
        // We want to ensure the space between title and image remains constant,
        // even when title view is moved to remain centered (but never resized).
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        
        titleView.addTarget(self, action: #selector(self.willToggle), for: .touchUpInside)
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "Lists"
        
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    public func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        
    }
    
    func willToggle(){
        if self.titleView.isUp{
            navigationBarMenu.hide()
        }else{
            navigationBarMenu.show()
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
            firstCell.menuAction = #selector(dropDownAction(_:))
            firstCell.menuTarget = self
            if currentChoice == list {
                firstCell.accessoryType = .checkmark
            }
            
            menuCellArray.append(firstCell)
        }

        navigationBarMenu.menuCells = menuCellArray
        navigationBarMenu.selectMenuCell(menuCellArray[0])
        
        // If we set the container to the controller view, the value must be set
        // on the hidden content offset (not the visible one)
        navigationBarMenu.visibleContentOffset =
            navigationController!.navigationBar.frame.size.height + 24
        
        // For a simple gray overlay in background
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    func dropDownAction(_ sender: AnyObject) {
        
        print("\n\ndrop down action\n\n")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - Layout view elements

extension ContactsViewController {
    
    // Setup all views
    func setupViews() {
        setupCollectionView()
        setupTopNavBarView()
        setupBottomNavBarView()
    }
    
    // Setup individual views
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
    
    func setupTopNavBarView() {
        
    }
    
}

// MARK: - Navigation methods (buttons)

extension ContactsViewController: BottomNavBarDelegate {
    
    func navToSettingsVC() {
        let destVC = SettingsViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func selectBtnClicked() {
        let destVC = ContactsViewController()
        navigationController?.pushViewController(destVC, animated: false)
        print("\n\n Select Button Clicked Working")
        
    }
    
    func addContactButtonPressed() {
        
        navToAddContactBtnVC()
    }
    
    func sendToButtonPressed() {
        
        navToRecordCardVC()
    }
    
    func navToAddContactBtnVC() {
        let destVC = AddContactViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func navToRecordCardVC() {
         let _ = startCameraFromViewController(self, withDelegate: self)
    }
}

// MARK: - Firebase methods

extension ContactsViewController {
    
    func retrieveContactsFromDB( completion: @escaping (_ : [Contact])-> ()) {
        var contacts: [Contact] = []
        let contactBucketRef = ref.child("\(uid)/all/")
        contactBucketRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
            }
            completion(contacts)
        })
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
        cameraController.videoQuality = .typeIFrame1280x720
        present(cameraController, animated: true, completion: nil)
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
            //            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
            //                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(RecordCardViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
            //            }
        }
    }
    
}

// MARK: - UINavigationControllerDelegate

extension ContactsViewController: UINavigationControllerDelegate {
    
}
