//
//  EditCardViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/22/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit
import SnapKit
import MBProgressHUD

extension EditCardViewController {
    func layoutViewElements() {
        // Main view setup
        view.backgroundColor = UIColor.clear

        populateFramesImageViewList()
        
        // Frame scrollview
        frameScrollview = UIScrollView()
        frameScrollview.delegate = self
        view.addSubview(frameScrollview)
        frameScrollview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        frameScrollview.bounces = false
        frameScrollview.decelerationRate = UIScrollViewDecelerationRateFast
        frameScrollview.isPagingEnabled = true
        
        //frame stack view
        frameStackview = UIStackView(arrangedSubviews: frameImagesList)
        frameStackview.axis = .horizontal
        frameStackview.distribution = .fillEqually
        frameStackview.alignment = .fill
        frameStackview.contentMode = .scaleAspectFit
        frameScrollview.addSubview(frameStackview)
        frameStackview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Double(frameImagesList.count))
        }
        
        // Player view
        view.addSubview(playerView)
        playerView.frame = CGRect(x: self.view.frame.width * 0.12, y: self.view.frame.height * 0.11, width: self.view.frame.width * 0.77, height: self.view.frame.height * 0.77)
        playerView.playerLayer.frame = playerView.frame

        playerView.backgroundColor = UIColor.clear
        view.sendSubview(toBack: playerView)
        playerView.playerLayer.player = player
        
        // Play+pause button
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.backgroundColor = UIColor.clear
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(3).offset(-40)
            make.height.equalTo(self.playPauseButton.snp.width).dividedBy(2)
            make.center.equalToSuperview()
        }
        playPauseButton.addTarget(self, action: #selector(self.playPauseButtonPressed), for: .touchUpInside)
        
        // Save button
        saveButton.backgroundColor = UIColor.clear
        saveButton.setTitle("Save", for: .normal)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(3).offset(-40)
            make.height.equalTo(self.saveButton.snp.width).dividedBy(2)
            make.centerY.equalToSuperview()
            make.trailingMargin.equalToSuperview()
        }
        saveButton.addTarget(self, action: #selector(self.navToSendCardVC), for: .touchUpInside)
        
        
        initAndLayoutActivityIndicator()
        
    }
    
    func instantiateButtons() {
        saveButton = UIButton()
        playPauseButton = UIButton()
        addTextButton = UIButton()
        activityIndicator = UIActivityIndicatorView()
    }
    
    func populateFramesImageViewList() {
        let frameImageList: [UIImage] = [#imageLiteral(resourceName: "frame1"), #imageLiteral(resourceName: "frame2"), #imageLiteral(resourceName: "frame3"), #imageLiteral(resourceName: "frame4"), #imageLiteral(resourceName: "frame5"), #imageLiteral(resourceName: "frame6"), #imageLiteral(resourceName: "frame7"), #imageLiteral(resourceName: "frame8"), #imageLiteral(resourceName: "frame9")]
        
        for frameImage in frameImageList {
            let frameView = UIImageView(image: frameImage)
            frameView.contentMode = .scaleAspectFit
            frameImagesList.append(frameView)
        }
    }
    
    func initAndLayoutActivityIndicator() {
        spinnerActivity = MBProgressHUD()
        view.addSubview(spinnerActivity)
        spinnerActivity.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        spinnerActivity.mode = .determinateHorizontalBar
        spinnerActivity.label.text = "Processing video ...";
        spinnerActivity.isUserInteractionEnabled = false;
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.spinnerActivity.show(animated: true)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.spinnerActivity.hide(animated: true)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func doWorkWithProgress(progressHUD: MBProgressHUD) {
        var progress: Float = 0.0
        while progress < 1.0 {
            progress += 0.01
            DispatchQueue.main.async {
                progressHUD.progress = progress
            }
            usleep(50000)
        }
    }
}

