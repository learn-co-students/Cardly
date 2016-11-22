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

class RecordCardViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    var toggleCameraViewButton = UIButton()
    var recordButton = UIButton()
    var previewView = UIView()
    
    var bottomNavBar: BottomNavBarView!
    
    //video control properties
    
    let captureSession = AVCaptureSession()
    var videoCaptureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput = AVCaptureMovieFileOutput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutRecordViewElements()
        self.initializeCamera()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        layoutRecordViewElements()
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
    
    //MARK: - BUTTON METHODS
    
    func recordButtonPressed () {
        if self.movieFileOutput.isRecording {
            //stop recording
            self.movieFileOutput.stopRecording()
        }
        else {
            //start
            self.movieFileOutput.connection(withMediaType: AVMediaTypeVideo).videoOrientation = self.videoOrientation()
            self.movieFileOutput.maxRecordedDuration = self.maxRecordedDuration()
            self.movieFileOutput.startRecording(toOutputFileURL: URL(fileURLWithPath: self.videoFileLocation()), recordingDelegate: self)
            
        }
        self.updateRecordingButtonTitle()
    }
    
    func toggleCameraButtonPressed() {
        self.switchCameraInput()
    }
    
    //MARK: HELPER METHODS
    
    
    func videoOrientation() -> AVCaptureVideoOrientation {
        var videoOrientation: AVCaptureVideoOrientation!
        
        let phoneOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch phoneOrientation {
        case .portrait:
            videoOrientation = .portrait
            break
        case .landscapeRight:
            videoOrientation = .landscapeLeft
            break
        case .landscapeLeft:
            videoOrientation = .landscapeRight
            break
        case .portraitUpsideDown:
            videoOrientation = .portrait
            break
        default:
            videoOrientation = .portrait
            
        }
        
        return videoOrientation
    }
    
    func videoFileLocation() -> String {
        return NSTemporaryDirectory().appending("videoFile.mov")
    }
    
    func updateRecordingButtonTitle() {
        if !self.movieFileOutput.isRecording {
            print("setting to recording")
            recordButton.backgroundColor = UIColor.green
            recordButton.setTitle("Recording...", for: .normal)
        }
        else {
            print("stopping record, setting to record")
            recordButton.backgroundColor = UIColor.red
            recordButton.setTitle("Record", for: .normal)
        }
    }
    
    func maxRecordedDuration() -> CMTime {
        let seconds: Double = 10
        let preferredTimeScale: Int32 = 1
        return CMTime(seconds: seconds, preferredTimescale: preferredTimeScale)
    }
    
    func setVideoOrientation() {
        if let connection = self.previewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
                self.previewLayer?.frame = self.previewView.bounds
            }
        }
    }
    
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
                print("frame: \(view.frame)")
                print("frame: \(previewView.frame)")
                
                self.setVideoOrientation()
                
                self.captureSession.addOutput(self.movieFileOutput)
                
                self.captureSession.startRunning()
                
            } catch {
                print(error.localizedDescription)
                
            }
        }
    }
    
    //MARK: -AVCaptureFileOutputDelegate
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("Finished recording: \(outputFileURL)")
    }
}
