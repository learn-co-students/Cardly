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
        
        //toolbarMenu.container = view
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
        
        let arrayofWeddingLists = ["All", "Family", "Friends", "Coworkers", "Other"]
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
        
        // create function that appends list name to the dropdown array
        
        //        let firstCell = DropDownMenuCell()
        //
        //        firstCell.textLabel!.text = "List 1"
        //        firstCell.menuAction = nil
        //        firstCell.menuTarget = self
        //        if currentChoice == "List 1" {
        //            firstCell.accessoryType = .checkmark
        //        }
        //
        //        let secondCell = DropDownMenuCell()
        //
        //        secondCell.textLabel!.text = "List 2"
        //        secondCell.menuAction = nil
        //        secondCell.menuTarget = self
        //        if currentChoice == "List 2" {
        //            firstCell.accessoryType = .checkmark
        //        }
        
        // navigationBarMenu.menuCells = [firstCell, secondCell]
        navigationBarMenu.menuCells = menuCellArray
        navigationBarMenu.selectMenuCell(menuCellArray[0])
        //navigationBarMenu.selectMenuCell(secondCell)
        
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
        // bottomNavBar.leftIconView.addContactBtn.target(forAction: #selector(self.navToAddContactBtnVC), withSender: nil)
        
        // bottomNavBar.rightIconView.sendToContactBtn.target(forAction: #selector(self.navToRecordCardVC), withSender: nil)
    }
    
    func setupTopNavBarView() {
        
    }
    
}

// MARK: - Navigation methods (buttons)

extension ContactsViewController: BottomNavBarDelegate {
    // code that contains all the selector methods that control which screen it goes to next.
    // the selector above will become the function name that i make here.
    // the function will have to get the navigation controller (by calling it)
    
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
        let destVC = RecordCardViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
}

// MARK: - Firebase methods

extension ContactsViewController {
    
    func retrieveContactsFromDB( completion: @escaping (_ : [Contact])-> ()) {
        var contacts: [Contact] = []
        let contactBucketRef = ref.child(uid)
        contactBucketRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
                //dump(self.contacts)
            }
            completion(contacts)
        })
    }
    
}
