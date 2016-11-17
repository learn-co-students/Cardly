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

class ContactsCollectionView: UICollectionView {
    let reuseIdentifier = "cell"
    let layout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        
        setupView()
        
        print("UICollectionView frame init called")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("UICollectionView decoder init called")
    }
    
    
    
    override func numberOfItems(inSection section: Int) -> Int {
        return 4
    }
    
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    func setupView() {
        register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.brown
        
    }

    
}
