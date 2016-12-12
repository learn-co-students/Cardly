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
    let shared = User.shared
    
    var firstTimeLoaded: Bool = true
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return User.shared.contacts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactsCollectionViewCell
        
        if indexPath.item == 0 {
            cell.addContactIconImageView.image = Icons.addContactButton
            return cell
        }
        
        cell.contact = User.shared.contacts[indexPath.row]
        
        cell.index = indexPath.row
        
        if cell.contact.is_sent == true {
            cell.alpha = 0.2
        }
        
        return cell
    }
    
    // Setup view
    func setupView() {
        delegate = self
        dataSource = self
        
        // Collection View properties
        showsVerticalScrollIndicator = false
        
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        backgroundView = UIView()
        let backgroundPlaneImage = UIImageView()
        backgroundPlaneImage.image = Icons.backgroundPlaneImage
        
        backgroundView!.addSubview(backgroundPlaneImage)
        backgroundPlaneImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.90)
            make.height.equalTo(backgroundPlaneImage.snp.width).multipliedBy(0.79)
        }
        
        // Create reuse cell
        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Cells layout
        let cellWidth = self.bounds.width * 0.40
        let cellHeight = cellWidth
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
    }
    
}

