//
//  RecordCardViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/21/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit

extension RecordCardViewController {
    
    func layoutRecordViewElements() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(previewView)
        previewView.frame = self.view.frame
        previewView.backgroundColor = UIColor.clear
        
        previewView.addSubview(recordButton)
        recordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-60)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(50)
        }
        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        recordButton.setTitle("Start recording", for: .normal)
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.backgroundColor = UIColor.red
        
        previewView.addSubview(toggleCameraViewButton)
        toggleCameraViewButton.snp.makeConstraints { (make) in
            make.width.equalTo(recordButton.snp.width).multipliedBy(1.0/3.0)
            make.height.equalTo(recordButton.snp.height)
            make.leadingMargin.equalTo(recordButton.snp.trailingMargin).offset(20)
            make.bottomMargin.equalToSuperview().offset(-60)
        }
        
        toggleCameraViewButton.setTitle("Toggle", for: .normal)
        toggleCameraViewButton.backgroundColor = UIColor.black
        toggleCameraViewButton.addTarget(self, action: #selector(self.toggleCameraButtonPressed), for: .touchUpInside)
    }
    
}
