//
//  ContactsBottomNavBarView.swift
//  PotatoParty
//
//  Created by Dave Neff on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Bottom Nav Bar Protocol

protocol BottomNavBarDelegate: class {
    func deleteButtonPressed()
    func sendToButtonPressed()
    func editGroupButtonPressed()
    
    
}

// MARK: - Bottom Nav Bar

class BottomNavBarView: UIView {
    var leftIconView = BottomNavBarLeftView()
    var middleIconView = BottomNavBarMiddleView()
    var rightIconView = BottomNavBarRightView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: - Nav Bar Individual Views

class BottomNavBarLeftView: UIView {
    var deleteContactBtn = UIButton()
    weak var delegate: BottomNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // Delete Button
        deleteContactBtn.setTitle("🗑", for: .normal)
        deleteContactBtn.setTitleColor(UIColor.black, for: .normal)
        deleteContactBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 32)
        deleteContactBtn.frame = CGRect()
        deleteContactBtn.isEnabled = false
        deleteContactBtn.isHidden = true
        deleteContactBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        addSubview(deleteContactBtn)
        deleteContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

//        // Change background from color to image
//        self.backgroundColor = UIColor.clear
//        let blur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blur)
//        self.addSubview(blurView)
    }

    func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonPressed()
    }
    
}

class BottomNavBarMiddleView: UIView{
    var editGroupButton = UIButton()
    
    weak var delegate: BottomNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        editGroupButton.setTitle("Edit Group", for: .normal)
        editGroupButton.setTitleColor(UIColor.black, for: .normal)
        editGroupButton.titleLabel?.font = UIFont(name: "Helvecta", size: 32)
        editGroupButton.frame = CGRect()
        editGroupButton.isEnabled = false
        editGroupButton.isHidden = true
        editGroupButton.addTarget(self, action: #selector(editGroupButtonTapped(_sender:)), for: .touchUpInside)
        addSubview(editGroupButton)
        editGroupButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
//        self.backgroundColor = UIColor.orange
    }
    
    func editGroupButtonTapped(_sender: UIButton) {
        delegate?.editGroupButtonPressed()
        print("editGroupButtonTapped")
    }
}


class BottomNavBarRightView: UIView {
    var sendToContactBtn = UIButton()
    weak var delegate: BottomNavBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        // send button
        
        sendToContactBtn.setTitle("Send", for: .normal)
        sendToContactBtn.setTitleColor(UIColor.black, for: .normal)
        sendToContactBtn.titleLabel?.font = UIFont(name: "Helvecta", size: 32)
        sendToContactBtn.frame = CGRect()
        sendToContactBtn.isEnabled = true
        sendToContactBtn.addTarget(self, action: #selector(sendToContactButtonTapped(_:)), for: .touchUpInside)
        addSubview(sendToContactBtn)
        sendToContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            
        }
        
//        self.backgroundColor = UIColor.red
    }
    
    func sendToContactButtonTapped(_ sender: UIButton) {
        
        print("\n\nsend to contact button pressed\n\n")
        delegate?.sendToButtonPressed()
        
    }
    
}


// MARK: - Extensions

extension BottomNavBarView {
    
    func setupView() {
        // Background
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        
        // Stack view
        let stackView = UIStackView()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(leftIconView)
        stackView.addArrangedSubview(middleIconView)
        stackView.addArrangedSubview(rightIconView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }

//    func addBlurEffect() {
//        self.backgroundColor = UIColor.clear
//        let blur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blur)
//        self.addSubview(blurView)
//    }
    
}

