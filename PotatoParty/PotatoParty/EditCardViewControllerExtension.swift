//
//  EditCardViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/22/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit
import SnapKit

extension EditCardViewController {
    
    func layoutViewElements() {
        // Main view setup
        view.backgroundColor = UIColor.clear
        
        // Player view
        view.addSubview(playerView)
        playerView.frame = self.view.frame
        playerView.backgroundColor = UIColor.clear
        playerView.playerLayer.frame = playerView.bounds
        
        // Play+pause button
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.backgroundColor = UIColor.red
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(3).offset(-40)
            make.height.equalTo(self.playPauseButton.snp.width).dividedBy(2)
            make.bottomMargin.equalToSuperview().offset(-20)
            make.leadingMargin.equalToSuperview()
        }
//        playPauseButton.isEnabled = false
        playPauseButton.addTarget(self, action: #selector(self.playPauseButtonPressed), for: .touchUpInside)
        
        // Save button
        saveButton.backgroundColor = UIColor.red
        saveButton.setTitle("Save", for: .normal)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(playPauseButton.snp.height)
            make.width.equalTo(playPauseButton.snp.width)
            make.bottomMargin.equalToSuperview().offset(-20)
            make.trailingMargin.equalToSuperview()
        }
        saveButton.addTarget(self, action: #selector(self.navToSendCardVC), for: .touchUpInside)
        
        // Text button
        addTextButton.backgroundColor = UIColor.green
        addTextButton.setTitle("Text", for: .normal)
        view.addSubview(addTextButton)
        addTextButton.snp.makeConstraints { (make) in
            make.height.equalTo(playPauseButton.snp.height)
            make.width.equalTo(playPauseButton.snp.width)
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-20)
        }
        addTextButton.addTarget(self, action: #selector(self.addTextToVideo), for: .touchUpInside)
        
        // Activity indicator
        playerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
    }
    
    
    func instantiateButtons() {
        saveButton = UIButton()
        playPauseButton = UIButton()
        addTextButton = UIButton()
        activityIndicator = UIActivityIndicatorView()
    }
    
}
