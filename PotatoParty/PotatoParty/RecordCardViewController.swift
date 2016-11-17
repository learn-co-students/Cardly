//
//  RecordCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import CoreMedia

class RecordCardViewController: UIViewController {

    var toggleCameraViewButton = UIButton()
    var recordButton = UIButton()
    var previewView = UIView()
    
    
    //video control properties
    
    let captureSession = AVCaptureSession()
    var videoCaptureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput = AVCaptureMovieFileOutput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        self.initializeCamera()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.setVideoOrientation()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UI Elements
    
    func layoutElements() {
        
        view.backgroundColor = UIColor.orange
        
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-60)
            make.width.equalTo(40)
            make.height.equalTo(40)
           
        }
        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        recordButton.backgroundColor = UIColor.black
        
        
        view.addSubview(previewView)
        previewView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        previewView.backgroundColor = UIColor.blue
     
    }
    
    
    //MARK: - BUTTON METHODS
    
    func recordButtonPressed () {
        print("record button pressed")
    }
    
    //MARK: HELPER METHODS
    
    func videoOrientation() -> AVCaptureVideoOrientation {
        var videoOrienation: AVCaptureVideoOrientation!
        
        let phoneOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch phoneOrientation {
        case .portrait:
            videoOrienation = .portrait
            break
        case .landscapeRight:
            videoOrienation = .landscapeLeft
            break
        case .landscapeLeft:
            videoOrienation = .landscapeRight
            break
        case .portraitUpsideDown:
            videoOrienation = .portrait
            break
        default:
            videoOrienation = .portrait
            
        }
        
        return videoOrienation
    }
    
    func setVideoOrientation() {
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
                self.previewLayer?.frame = previewView.bounds
            }
        }
    }
    
    func initializeCamera() {
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let discovery = AVCaptureDeviceDiscoverySession.init(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) as AVCaptureDeviceDiscoverySession
        
        for device in discovery.devices as [AVCaptureDevice] {
            if device.position == AVCaptureDevicePosition.back {
                self.videoCaptureDevice = device
            }
        }
        if videoCaptureDevice != nil {
            do {
                try self.captureSession.addInput(AVCaptureDeviceInput(device: self.videoCaptureDevice))
                if let audioInput = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) {
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput))
                }
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewView.layer.addSublayer((self.previewLayer)!)
                self.previewLayer?.frame = self.previewView.frame
                
                self.setVideoOrientation()
                
                self.captureSession.addOutput(self.movieFileOutput)
                
                self.captureSession.startRunning()
                
            } catch {
                print(error)
                
            }
        }
    }
}
