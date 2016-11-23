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
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupView()
        print(#function)
    }
    
    // Setup view
    func setupView() {
        backgroundColor = UIColor.cyan
        
        label.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        label.font = UIFont(name: "Helvetica", size: 20)
        contentView.addSubview(label)
        label.isUserInteractionEnabled = true
        
        label.snp.makeConstraints { (make) in
            make.center.equalTo(contentView.center)
        }
        
    }
    
    func handleTap() {
        
        print(#function)
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
