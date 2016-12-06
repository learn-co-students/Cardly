//
//  ContactsCollectionView.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell"
    let layout = UICollectionViewFlowLayout()
    let defaultContact: Contact = Contact(fullName: "Add Contact", email: "", phone: "")
    var contacts: [Contact] = []
    weak var contactDelegate: AddContactsDelegate?
    //  var contactsBackgroundImage: UIImage = #imageLiteral(resourceName: "contactsAndSettingsVCBackgroundImage")
    let shared = User.shared
    var selectedCellIndexPath: IndexPath?
    
    
    // Inititalizers
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Cell data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contacts.insert(defaultContact, at: 0)
        return self.contacts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactsCollectionViewCell
        
        cell.contact = contacts[indexPath.row]
        
        if cell.contact.is_sent == true {
            cell.alpha = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
        print(#function)
        
        let selectedContact = contacts[indexPath.row]
        
        if indexPath.row == 0 {
            contactDelegate?.goToAddContact()
            
        } else {
            if selectedContact.isChosen == true {
                
                let selectedCell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
                selectedCell.handleTap()
                contacts[indexPath.row].isChosen = false
                shared.selectedContacts = shared.selectedContacts.filter({ (contact) -> Bool in
                    return contact.email != contacts[indexPath.row].email
                })
                
                print("deselected a cell")
                print("\(shared.selectedContacts)")
            } else {
                shared.selectedContacts.append(selectedContact)
                let selectedCell = collectionView.cellForItem(at: indexPath) as! ContactsCollectionViewCell
                selectedCell.handleTap()
                contacts[indexPath.row].isChosen = true
                print("selected cell")
                print("\(shared.selectedContacts)")
                
            }
            
        }
        
    }
    
    
    
    // Setup view
    func setupView() {
        delegate = self
        dataSource = self
        
        // Collection View properties
        backgroundColor = UIColor.brown
        // backgroundColor = UIColor.init(patternImage: contactsBackgroundImage) // NOTE: maybe not pattern
        
        // Create reuse cell
        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Cells layout
        let cellWidth = self.frame.width * 0.45
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        
    }
    
    //default cell
    func setupDefaultCellView() {
        let cellWidth = self.frame.width * 0.45
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
    
    
    
    
}

