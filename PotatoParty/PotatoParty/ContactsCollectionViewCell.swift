//
//  ContactsCollectionViewCell.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsCollectionViewCell: UICollectionViewCell {
    
    var cellCircleImageView = UIImageView()
    var label = UILabel()
    var highlightedTextColor: UIColor?
    var isChosen: Bool = false {
        didSet {
            isChosen ? reflectSelectedState() : reflectUnsellectedState()
        }
    }
    
    var contact: Contact! {
        didSet {
            label.text = "\(contact.fullName)\n\(contact.email)"
            isChosen = contact.isChosen
        }
    }
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Setup view
    func setupView() {
        // Background
        backgroundColor = UIColor.clear
        
        // Add circle image
        cellCircleImageView.image = UIImage(named: "contactsCellIcon")
        contentView.addSubview(cellCircleImageView)
        cellCircleImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }

        // Add label
        label.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        label.font = UIFont(name: Font.name, size: Font.Size.l)
        contentView.addSubview(label)
        label.isUserInteractionEnabled = true
        
        label.snp.makeConstraints { (make) in
            make.center.equalTo(contentView.center)
        }
        
    }
    
    func handleTap() {
        isChosen = !isChosen
    }
    
}


extension ContactsCollectionViewCell {
    
    func reflectSelectedState() {
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 4.0
    }
    
    func reflectUnsellectedState() {
        contentView.layer.borderWidth = 0.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        
    }
    
}
