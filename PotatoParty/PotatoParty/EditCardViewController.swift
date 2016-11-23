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
        
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: fileLocation!)
        
        let track = asset.tracks(withMediaType: AVMediaTypeVideo)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timerange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        do {
            try compositionVideoTrack.insertTimeRange(timerange, of: videoTrack, at: kCMTimeZero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch  {
            print(error)
        }
        
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        for audioTrack in asset.tracks(withMediaType: AVMediaTypeAudio) {
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: kCMTimeZero)
            } catch {
                print(error)
            }
            
            let size = videoTrack.naturalSize
            
            // Set up watermark/overlays (probably should use snapkit)
            let watermark = UIImage(named: "watermark.png")
            let watermarklayer = CALayer()
            watermarklayer.contents = watermark?.cgImage
            watermarklayer.frame = CGRect(x: 10, y: 10, width: 180, height: 180)
            watermarklayer.opacity = 0.5
            
            let textLayer = CATextLayer()
            textLayer.string = "DOWNLOAD POTATO PARTY OR DIE"
            textLayer.font = UIFont(name: "Helvetica", size: 65.0)
            textLayer.shadowOpacity = 0.5
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height/6)
            
            let videoLayer = CALayer()
            videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let parentLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(watermarklayer)
            parentLayer.addSublayer(textLayer)
            
            let layercomposition = AVMutableVideoComposition()
            layercomposition.frameDuration = CMTimeMake(1, 30)
            layercomposition.renderSize = size
            layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
            let videoTrack = composition.tracks(withMediaType: AVMediaTypeVideo)[0] as AVAssetTrack
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
            instruction.layerInstructions = [layerInstruction]
            layercomposition.instructions = [instruction]
            
            let filePath = NSTemporaryDirectory() + fileName()
            let movieUrl = URL(fileURLWithPath: filePath)
            
            guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
            assetExport.videoComposition = layercomposition
            assetExport.outputFileType = AVFileTypeMPEG4
            assetExport.outputURL = movieUrl
            
            assetExport.exportAsynchronously {
                switch assetExport.status {
                case .completed:
                    print("Success")
                    self.fileLocation = movieUrl
                    
                    //send out video
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
        print("Play pause button pressedd")
        updatePlayPauseButtonTitle()
    }
    
    
    // MARK: - Helpers
    
    func updatePlayPauseButtonTitle() {
        if player.rate > 0 {
            //playing
            print("Pausing video")
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            //paused / stopped
            print("Playing video")
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
        print("save button pressed!!!")
        let destVC = SendCardViewController()
        destVC.videoURL = fileLocation
        navigationController?.pushViewController(destVC, animated: true)
    }

}
