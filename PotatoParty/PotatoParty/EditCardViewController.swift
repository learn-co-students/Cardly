//
//  EditCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class EditCardViewController: UIViewController, UITextFieldDelegate{

    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]
    
    var playerView = PlayerView()
    var saveButton = UIButton()
    var playPauseButton = UIButton()
    var addOverlayButton = UIButton()
    var stopButton = UIButton()
    var addTextButton = UIButton()
    
    let player = AVPlayer()
    var asset: AVURLAsset? {
        didSet {
            print("new asset created \(asset)")
            guard let newAsset = asset else { return }
            loadURLAsset(newAsset)
        }
    }
    var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    var playerItem: AVPlayerItem? {
        didSet {
            
            //self.addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
            player.replaceCurrentItem(with: playerItem)
            player.actionAtItemEnd = .none
            player.play()
            player.pause()
        }
    }
    
    var fileLocation: URL? {
        didSet {
            asset = AVURLAsset(url: fileLocation!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViewElements()
        playerView.playerLayer.player = player
        playerView.playerLayer.frame = view.bounds
        
        //addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        //player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //removeObserver(self, forKeyPath: "player.currentItem.status")
    }
    
    // MARK: - Main
    func loadURLAsset(_ asset: AVURLAsset) {
        asset.loadValuesAsynchronously(forKeys: EditCardViewController.assetKeysRequiredToPlay, completionHandler: {
            
                for key in EditCardViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if !asset.isPlayable || asset.hasProtectedContent {
                        let message = "Video is not playable"
                        self.showAlert(title: "Error", message: message, dismiss: false)
                        return
                    }
                    
                    if asset.statusOfValue(forKey: key, error: &error) == .failed {
                        let message = "Failed to load"
                        self.showAlert(title: "Error", message: message, dismiss: false)
                    }
                }
                self.playerItem = AVPlayerItem(asset: asset)
        })
    }
    
    func exportWithFrameLayer() {
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: fileLocation!)
        
        let track = asset.tracks(withMediaType: AVMediaTypeVideo)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timerange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: kCMTimeZero)
        } catch  {
            print("composing video track error")
            print(error)
        }
        
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        for audioTrack in asset.tracks(withMediaType: AVMediaTypeAudio) {
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: kCMTimeZero)
            } catch {
                print("composing audio track error")
                print(error)
            }
        }
        
        let overlayImage = UIImage(named: "thankYou")
        let overlayLayer = CALayer()
        overlayLayer.contents = overlayImage?.cgImage
        overlayLayer.frame = playerView.playerLayer.bounds
        
        let videoLayer = CALayer()
        videoLayer.backgroundColor = UIColor.blue.cgColor
        videoLayer.frame = overlayLayer.frame
        
        let parentLayer = CALayer()
        parentLayer.frame = playerView.playerLayer.bounds
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
            
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = view.frame.size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer:videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let layerInstr = videoCompositionInstructionForTrack(track: compositionVideoTrack, assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
        
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
            
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = movieUrl

        assetExport.exportAsynchronously {
            DispatchQueue.main.async {
                switch assetExport.status {
                case .completed:
                    print("Success")
                    self.fileLocation = movieUrl
                    let player2 = AVPlayer(url: movieUrl)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player2
                    self.present(playerViewController, animated: true) { () -> Void in
                        player2.play()
                    }
                    break
                case.cancelled:
                    print("Canceled")
                    break
                case .exporting:
                    print("Exporting")
                    break
                case .failed:
                    print("Failed \(assetExport.error)")
                    break
                case.unknown:
                    print("Unknown error")
                    break
                case.waiting:
                    print("Waiting")
                }

            }
        }
        
    }
    
    func overlayText(_ text: String) {
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: fileLocation!)
        
        let track = asset.tracks(withMediaType: AVMediaTypeVideo)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timerange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: kCMTimeZero)
        } catch  {
            print("composing video track error")
            print(error)
        }
        
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        for audioTrack in asset.tracks(withMediaType: AVMediaTypeAudio) {
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: kCMTimeZero)
            } catch {
                print("composing audio track error")
                print(error)
            }
        }
        
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.font = UIFont(name: "Helvetica", size: 15.0)
        textLayer.shadowOpacity = 0.5
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.frame = CGRect(x: 0, y: 50, width: playerView.playerLayer.bounds.width, height: playerView.playerLayer.bounds.height/8)
        
        let videoLayer = CALayer()
        videoLayer.backgroundColor = UIColor.blue.cgColor
        videoLayer.frame = CGRect(x: 0, y: 0, width: playerView.playerLayer.bounds.width, height: playerView.playerLayer.bounds.height)
        
        let parentLayer = CALayer()
        parentLayer.frame = playerView.playerLayer.bounds
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(textLayer)
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = view.frame.size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer:videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let layerInstr = videoCompositionInstructionForTrack(track: compositionVideoTrack, assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
        
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
        
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = movieUrl
        
        assetExport.exportAsynchronously {
            DispatchQueue.main.async(execute: {
                switch assetExport.status {
                case .completed:
                    print("Success")
                    self.fileLocation = movieUrl
                    break
                case.cancelled:
                    print("Canceled")
                    break
                case .exporting:
                    print("Exporting")
                    break
                case .failed:
                    print("Failed \(assetExport.error)")
                    break
                case.unknown:
                    print("Unknown error")
                    break
                case.waiting:
                    print("Waiting")
                }

            })
                    }
    }
    
    // MARK: - Correct video orientation
    
    func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
        var assetOrientation = UIImageOrientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    func videoCompositionInstructionForTrack(track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = assetTrack
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        var scaleToFitRatio = playerView.playerLayer.bounds.width / assetTrack.naturalSize.width
        
        if assetInfo.isPortrait {
            scaleToFitRatio = playerView.playerLayer.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                    at: kCMTimeZero)
        }
        else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: playerView.playerLayer.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                let windowBounds = playerView.playerLayer.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: kCMTimeZero)
        }
      
        return instruction
    }
    
    // MARK: - Callbacks
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "player.currentItem.status" {
            print("observer is triggered")
            //playPauseButton.isHidden = false
            //saveButton.isHidden = false
            if player.status == AVPlayerStatus.readyToPlay {
                print("goes into if of observer for readyToPlayer")
                playPauseButton.isEnabled = true
            }
        }

    }
    
    // MARK: - Actions
    
    
    func playerReachedEnd(notification: NSNotification) {
        asset = AVURLAsset(url: fileLocation!)
    }
    
    func closePreview() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveToLibrary() {
        
    }
    
    func playPauseButtonPressed() {
        updatePlayPauseButtonTitle()
    }
    
    
    // MARK: - Helpers
    
    func updatePlayPauseButtonTitle() {
        if player.rate > 0 {
            //playing
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            //paused / stopped
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    func addTextToVideo() {
        let alertController = UIAlertController(title: "Text to overlay", message: "Must be 15 characters or less", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.delegate = self
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            self.overlayText((alertController.textFields?[0].text!)!)
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newString.characters.count <= 15
    }
    
    func showAlert(title:String, message:String, dismiss:Bool) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if dismiss {
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func fileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyhhmmss"
        return formatter.string(from: Date()) + ".mp4"
    }
    
    // MARK: Navigation
    
    func navToSendCardVC() {
        let destVC = SendCardViewController()
        destVC.videoURL = fileLocation
        navigationController?.pushViewController(destVC, animated: true)
    }

}
