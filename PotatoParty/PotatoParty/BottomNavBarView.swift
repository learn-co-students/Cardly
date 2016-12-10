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
        deleteContactBtn.setImage(Icons.deleteButton, for: .normal)
        deleteContactBtn.isEnabled = false
        deleteContactBtn.isHidden = true
        deleteContactBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        addSubview(deleteContactBtn)
        deleteContactBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Icons.multiplier)
            make.width.equalTo(deleteContactBtn.snp.height)
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
        editGroupButton.setImage(Icons.editGroupsButton, for: .normal)
        editGroupButton.isEnabled = false
        editGroupButton.isHidden = true
        editGroupButton.addTarget(self, action: #selector(editGroupButtonTapped(_sender:)), for: .touchUpInside)
        addSubview(editGroupButton)
        editGroupButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Icons.multiplier)
            make.width.equalTo(editGroupButton.snp.height)
        }
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
        // Button setup
        addSubview(sendToContactBtn)
        sendToContactBtn.setImage(Icons.recordVideoButton, for: .normal)
        sendToContactBtn.isEnabled = true
        sendToContactBtn.addTarget(self, action: #selector(sendToContactButtonTapped(_:)), for: .touchUpInside)
        sendToContactBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Icons.multiplier)
            make.width.equalTo(sendToContactBtn.snp.height)
        }
    }
    
    func sendToContactButtonTapped(_ sender: UIButton) {
        delegate?.sendToButtonPressed()
    }
    
}


// MARK: - Extensions

extension BottomNavBarView {
    
    func setupView() {
        backgroundColor = UIColor.clear
        
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
    
}

