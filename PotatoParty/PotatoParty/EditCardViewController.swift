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
import AssetsLibrary
import Photos
import MBProgressHUD

class EditCardViewController: UIViewController, UITextFieldDelegate {

    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var fileLocation: URL? {
        didSet {
            asset = AVURLAsset(url: fileLocation!)
        }
    }

    let HDVideoSize = CGSize(width: 1080.0, height: 1920.0)

    // Player
    var playerView = PlayerView()
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
    var activityIndicator: UIActivityIndicatorView!
    var spinnerActivity: MBProgressHUD!
    var progressObj: Progress!
    var selectedImageIndex = 0

    // Buttons
    var saveButton: UIButton!
    var playPauseButton: UIButton!
    var addTextButton: UIButton!
    lazy var buttons: [UIButton] = [self.saveButton, self.playPauseButton, self.addTextButton]
    var frameScrollview: UIScrollView!
    var frameStackview: UIStackView!
    var frame1View: UIImageView!
    var frame2View: UIImageView!
    var frameImagesList: [UIImageView] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateButtons()
        layoutViewElements()
        
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        removeObserver(self, forKeyPath: "player.currentItem.status")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    // MARK: - Add overlay methods
    
    func exportWithFrameLayer(completion: @escaping (Bool) -> Void) {
        // Composition
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
        
        // Layers
        let overlayImage = frameImagesList[selectedImageIndex].image
        let overlayLayer = CALayer()
        overlayLayer.contents = overlayImage?.cgImage
        overlayLayer.frame = CGRect(x: 0, y: 0, width: HDVideoSize.width, height: HDVideoSize.height)
        
        let videoLayer = CALayer()
        videoLayer.backgroundColor = UIColor.blue.cgColor
        videoLayer.frame = CGRect(x: 120, y: 230, width: HDVideoSize.width * 0.78, height: HDVideoSize.height * 0.78)
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: HDVideoSize.width, height: HDVideoSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
            
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = HDVideoSize
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer:videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let layerInstr = videoCompositionInstructionForTrack(track: compositionVideoTrack, assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
    
        // Export
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
    
        guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = movieUrl
        startActivityIndicator()

        assetExport.exportAsynchronously {
            switch assetExport.status {
            case .completed:
                print("Success")
                self.doWorkWithProgress(progressHUD: self.spinnerActivity)
                self.fileLocation = movieUrl
                self.stopActivityIndicator()
                completion(true)
            case .failed:
                fatalError("Image export failed!")
            default:
                fatalError("Failed to export image")
            }
        }
    }
    
    func overlayText(_ text: String) {
        // Composition
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
        
        do {
            try compositionAudioTrack.insertTimeRange(timerange, of: asset.tracks(withMediaType: AVMediaTypeAudio)[0], at: kCMTimeZero)
        } catch {
            print("composing audio track error")
            print(error)
        }
        
        // Layers
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.font = UIFont(name: "Helvetica", size: 15.0)
        textLayer.shadowOpacity = 0.5
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.frame = CGRect(x: 0, y: 60, width: HDVideoSize.width, height: HDVideoSize.height / 2)
        
        let videoLayer = CALayer()
        videoLayer.backgroundColor = UIColor.blue.cgColor
        videoLayer.frame = CGRect(x: 0, y: 0, width: HDVideoSize.width, height: HDVideoSize.height)
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: HDVideoSize.width, height: HDVideoSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(textLayer)

        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = HDVideoSize
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let layerInstr = videoCompositionInstructionForText(track: compositionVideoTrack, assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
        
        // Export
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
        
        guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
        assetExport.videoComposition = layercomposition
        assetExport.outputFileType = AVFileTypeQuickTimeMovie
        assetExport.outputURL = movieUrl
        startActivityIndicator()
        assetExport.exportAsynchronously {
            switch assetExport.status {
            case .completed:
                print("Success")
                self.doWorkWithProgress(progressHUD: self.spinnerActivity)
                self.fileLocation = movieUrl
                self.stopActivityIndicator()
            case .failed:
                fatalError("Image export failed!")
            default:
                fatalError("Failed to export image")
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
    
    
    // MARK: - Composition instructions
    func videoCompositionInstructionForTrack(track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = assetTrack
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        let scaleToFitRatio = HDVideoSize.width / HDVideoSize.width
        
        if assetInfo.isPortrait {
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
    
    func videoCompositionInstructionForText(track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let scaleFactor = CGAffineTransform(scaleX: 1, y: 1)
        instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: kCMTimeZero)
        return instruction
    }
    
    // MARK: - Callbacks
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "player.currentItem.status" {
            if player.status == AVPlayerStatus.readyToPlay {
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
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
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
    
    // MARK: - Navigation
    
    func navToSendCardVC(sender: UIButton, isExportSuccessful: Bool) {
        
        exportWithFrameLayer { (success) in
            if success {
                self.player.pause()
                let destVC = SendCardViewController()
                destVC.delegate = self
                destVC.fileLocation = self.fileLocation
                destVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(destVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Save video to photo library
    
    func saveVideoToPhotoLibrary(_ videoUrl: URL) {
        PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
            if authorizationStatus == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)}) { completed, error in
                        if completed {
                            print("Video asset created")
                        } else {
                            if let error = error { print(error) }
                        }
                }
            }
        })
    }

}

// MARK: - ScrollView delegate methods

extension EditCardViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentStackViewWidthValue = frameStackview.frame.width
        let widthMarker = currentStackViewWidthValue / CGFloat(frameImagesList.count)
        var index = Int(scrollView.contentOffset.x / widthMarker)
        if index >= frameImagesList.count {
            index -= 1
        }
        selectedImageIndex = index
    }
    
}

// MARK: - Modal VC handling

extension EditCardViewController: ModalViewControllerDelegate {
    
    func modalViewControllerDidDisappear(completion: @escaping () -> Void) {
        dismiss(animated: false, completion: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
        completion()
    }
}
