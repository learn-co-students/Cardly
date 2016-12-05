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
        playerView.frame = self.view.frame
        playerView.backgroundColor = UIColor.clear
        playerView.playerLayer.frame = playerView.bounds
        view.sendSubview(toBack: playerView)
        playerView.playerLayer.player = player
        
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
        spinnerActivity.label.text = "Processing image ...";
        spinnerActivity.isUserInteractionEnabled = false;
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.spinnerActivity.show(animated: true)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.spinnerActivity.hide(animated: true)
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

extension EditCardViewController: UITextFieldDelegate {
    func setupText() {
        let font = UIFont(name: Font.nameForCard, size: Font.Size.cardView)
        
        // Top text field
        topTextField = UITextField()
        topTextField.delegate = self
        view.addSubview(topTextField)
        topTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(-10)
        }
        // Text
        topTextField.text = "Hey Carl,"
        topTextField.font = font
        topTextField.textAlignment = .left
        topTextField.textColor = UIColor.white
        topTextField.backgroundColor = UIColor.clear
        // Drop shadow
        topTextField.layer.shadowColor = UIColor.black.cgColor
        topTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        topTextField.layer.shadowRadius = 0
        topTextField.layer.shadowOpacity = 1
        
        // Bottom text field
        bottomTextField = UITextField()
        bottomTextField.delegate = self
        
//        MARK: - Uncomment to enable bottom text field
//        view.addSubview(bottomTextField)
//        bottomTextField.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-30)
//            make.left.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
        
        // Text attributes
        bottomTextField.text = "Love, Forrest"
        bottomTextField.font = font
        bottomTextField.textAlignment = .right
        bottomTextField.textColor = UIColor.white
        bottomTextField.backgroundColor = UIColor.clear
        // Text drop shadow
        bottomTextField.layer.shadowColor = UIColor.black.cgColor
        bottomTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        bottomTextField.layer.shadowRadius = 0
        bottomTextField.layer.shadowOpacity = 1
    }
    
    // Press enter to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

