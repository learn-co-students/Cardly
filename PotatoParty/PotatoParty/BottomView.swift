//
//  BottomView.swift
//  PotatoParty
//
//  Created by Michelle Staton on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit

class BottomView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var middleButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Getting called")
        commonInit()
    }
    
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("BottomView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        contentView.constrainEdges(to: self)
        
    }


}


extension UIView {
    
    func constrainEdges(to view: UIView) {
        
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
    }
    
}
