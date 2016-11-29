//
//  EditCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import AVFoundation

class EditCardViewController: UIViewController {

    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]
    
    var playerView = PlayerView()
    var saveButton = UIButton()
    var playPauseButton = UIButton()
    var addOverlayButton = UIButton()
    var stopButton = UIButton()
    
    let player = AVPlayer()
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            loadURLAsset(newAsset)
        }
    }
    var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    var playerItem: AVPlayerItem? {
        didSet {
            player.replaceCurrentItem(with: playerItem)
            player.actionAtItemEnd = .none
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
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.alpha = 0.0
        
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver(self, forKeyPath: "player.currentItem.status")
    }
    
    // MARK: - Main
    func loadURLAsset(_ asset: AVURLAsset) {
        asset.loadValuesAsynchronously(forKeys: EditCardViewController.assetKeysRequiredToPlay, completionHandler: {
            DispatchQueue.main.async {
                guard asset == self.asset else { return }
                
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
            }
        })
    }
    
    func exportWithWatermark() {
        
        playerView.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect
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
        
//        let watermark = UIImage(named: "watermark.png")
//        let watermarklayer = CALayer()
//        watermarklayer.contents = watermark?.cgImage
//        watermarklayer.frame = CGRect(x: 10, y: 10, width: 180, height: 180)
//        watermarklayer.opacity = 0.5
//            
//        let textLayer = CATextLayer()
//        textLayer.string = "DOWNLOAD POTATO PARTY OR DIE"
//        textLayer.font = UIFont(name: "Helvetica", size: 65.0)
//        textLayer.shadowOpacity = 0.5
//        textLayer.alignmentMode = kCAAlignmentCenter
//        textLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height/6)
        
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
        let layerInstr = videoCompositionInstructionForTrack(track: compositionVideoTrack, asset: asset)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
        
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
            
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = movieUrl
            
        assetExport.exportAsynchronously {
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
    
    func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
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
            playPauseButton.isHidden = false
            saveButton.isHidden = false
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
