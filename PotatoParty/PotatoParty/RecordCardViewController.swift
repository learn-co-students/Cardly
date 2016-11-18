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
        layoutElements()
        self.setVideoOrientation()
        print("VIEW WILL LAYOUT SUBVIEWS: previewLayerFrame: \(previewLayer?.frame). previewViewFrame: \(previewView.frame)")
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
        print("layout elements called")
        view.backgroundColor = UIColor.orange
        
//        view.addSubview(recordButton)
//        recordButton.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.bottomMargin.equalToSuperview().offset(-60)
//            make.width.equalTo(40)
//            make.height.equalTo(40)
//           
//        }
//        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
//        recordButton.backgroundColor = UIColor.black
        
       
        
//        previewView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        
        
        view.addSubview(previewView)
        previewView.frame = self.view.frame
        
        previewView.backgroundColor = UIColor.blue
        print("preview view frame: \(previewView.frame)")
        
        view.addSubview(toggleCameraViewButton)
        toggleCameraViewButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.rightMargin.equalTo(self.view.snp.rightMargin).offset(-40)
            make.topMargin.equalTo(self.view.snp.topMargin).offset(50)
        }
        
        toggleCameraViewButton.setTitle("Toggle", for: .normal)
        toggleCameraViewButton.backgroundColor = UIColor.black
        toggleCameraViewButton.addTarget(self, action: #selector(self.toggleCameraButtonPressed), for: .touchUpInside)
            }
    
    
    //MARK: - BUTTON METHODS
    
    func recordButtonPressed () {
        print("record button pressed")
    }
    
    func toggleCameraButtonPressed() {
        print("toggle Camera Button Pressed")
    self.switchCameraInput()
    }
    
    //MARK: HELPER METHODS
    
    // Orientation Methods
    
    func videoOrientation() -> AVCaptureVideoOrientation {
        print("video orientation function called")
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
        print("set video Orientation called")
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
                self.previewLayer?.frame = self.previewView.bounds
                
                print("previewLayerFrame: \(previewLayer?.frame). previewViewFrame: \(previewView.frame)")
            }
        }
    }
    
    //toggling camera methods 
    
    func switchCameraInput() {
        self.captureSession.beginConfiguration()
        var existingConnection: AVCaptureDeviceInput!
        
        for connection in self.captureSession.inputs {
            let input = connection as! AVCaptureDeviceInput
            if input.device.hasMediaType(AVMediaTypeVideo) {
                existingConnection = input
            }
        }
        
        self.captureSession.removeInput(existingConnection)
        
        var newCamera: AVCaptureDevice!
        
        if let oldCamera = existingConnection {
            if oldCamera.device.position == .back {
                newCamera = self.cameraWithPostion(position: .front)
            } else {
                newCamera = self.cameraWithPostion(position: .back)
            }
        }
        var newInput: AVCaptureDeviceInput!
        
        do {
            newInput = try AVCaptureDeviceInput(device: newCamera)
            self.captureSession.addInput(newInput)
        } catch {
            print(error)
        }
        self.captureSession.commitConfiguration()
    }
    
    
    
    func cameraWithPostion(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let discovery = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) as AVCaptureDeviceDiscoverySession
        
        for device in discovery.devices as [AVCaptureDevice] {
            if device.position == position {
            return device
            }
        }
        
        return nil
    }
    
    //Initializing Camera
    
    func initializeCamera() {
        print("initialize camera called")
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
                print("frame: \(view.frame)")
                print("frame: \(previewView.frame)")
                
                self.setVideoOrientation()
                
                self.captureSession.addOutput(self.movieFileOutput)
                
                self.captureSession.startRunning()
                
            } catch {
                print(error)
                
            }
        }
    }
    
    
}
