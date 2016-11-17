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
    // Properties
    let reuseIdentifier = "cell"
    let layout = UICollectionViewFlowLayout()
    
    // Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Cell Data Source methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    func setupView() {
        delegate = self
        dataSource = self

        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .vertical
        
        backgroundColor = UIColor.brown
    
    }

    
}
