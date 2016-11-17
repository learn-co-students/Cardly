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

class ContactsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let layout = UICollectionViewFlowLayout()
    let reuseIdentifier = "cell"
    
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    // Setup view
    func setupView() {
        delegate = self
        dataSource = self
        
        // View properties
        backgroundColor = UIColor.brown
        
        // Create reuse cell
        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Cells layout
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
    }
    
}
