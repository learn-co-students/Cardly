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
    var addContactIconImageView = UIImageView()
    var index = -1
    
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
    override func prepareForReuse() {
        super.prepareForReuse()
        addContactIconImageView.image = nil
        label.text = nil
        isChosen = false
    }
    
    func setupView() {
        // Background
        backgroundColor = UIColor.clear
        
        // Add circle image
        cellCircleImageView.image = UIImage(named: "contactsCellIcon")
        cellCircleImageView.alpha = 0.90
        contentView.addSubview(cellCircleImageView)
        cellCircleImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        // Circle drop shadow
        cellCircleImageView.layer.shadowColor = UIColor.black.cgColor
        cellCircleImageView.layer.shadowOpacity = 0.3
        cellCircleImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cellCircleImageView.layer.shadowRadius = 1
        
        // Add 'Add Contact' image
        contentView.addSubview(addContactIconImageView)
        addContactIconImageView.snp.makeConstraints { (make) in
            make.height.equalTo(contentView).multipliedBy(0.50)
            make.width.equalTo(addContactIconImageView.snp.height).multipliedBy(0.72)
            make.center.equalTo(contentView.snp.center)
        }
        
        // Add label
        label.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        label.font = UIFont(name: Font.regular, size: Font.Size.m)
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
        contentView.layer.shadowRadius = 6.0
        contentView.layer.shadowColor = UIColor.yellow.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.75
    }
    
    func reflectUnsellectedState() {
        contentView.layer.shadowOpacity = 0
    }
    
}
