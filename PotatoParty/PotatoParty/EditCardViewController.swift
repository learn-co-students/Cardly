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
import SnapKit


class EditCardViewController: UIViewController {

    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var fileLocation: URL? {
        didSet {
            asset = AVURLAsset(url: fileLocation!)
        }
    }

    let HDVideoSize = CGSize(width: 720.0, height: 1280.0)

    // Video player
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

    var saveButton: UIButton!
    var playPauseButton: UIButton!
    var addTextButton: UIButton!
    lazy var buttons: [UIButton] = [self.saveButton, self.playPauseButton, self.addTextButton]
    
    var frameScrollview: UIScrollView!
    var frameStackview: UIStackView!
    var frame1View: UIImageView!
    var frame2View: UIImageView!
    var frameImagesList: [UIImageView] = []
    
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateButtons()
        layoutViewElements()
        setupText()
        registerForKeyboardNotifications()
        addObserver(self, forKeyPath: "player.currentItem.status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        removeObserver(self, forKeyPath: "player.currentItem.status")
        deregisterFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - Layout view elements
    
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
        
        view.addSubview(playerView)
        playerView.frame = CGRect(x: self.view.frame.width * 0.12, y: self.view.frame.height * 0.11, width: self.view.frame.width * 0.77, height: self.view.frame.height * 0.77)
        playerView.playerLayer.frame = playerView.frame
        
        playerView.backgroundColor = UIColor.clear
        view.sendSubview(toBack: playerView)
        playerView.playerLayer.player = player
        
        playPauseButton = UIButton()
        playPauseButton.setImage(Icons.playButton, for: .normal)
        playPauseButton.alpha = 0.3
        playPauseButton.contentMode = .scaleAspectFit
        playPauseButton.contentVerticalAlignment = .fill
        playPauseButton.contentHorizontalAlignment = .fill
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(view.snp.width).multipliedBy(0.3)
            make.center.equalToSuperview()
            print("play button width is currently \(playPauseButton.frame.width)")
        }
        playPauseButton.addTarget(self, action: #selector(self.playPauseButtonPressed), for: .touchUpInside)
        
        saveButton = UIButton()
        saveButton.setImage(Icons.saveButton, for: .normal)
        saveButton.contentMode = .scaleAspectFit
        saveButton.contentVerticalAlignment = .fill
        saveButton.contentHorizontalAlignment = .fill
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.1)
            make.height.equalTo(view.snp.width).multipliedBy(0.1)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        saveButton.addTarget(self, action: #selector(self.navToSendCardVC), for: .touchUpInside)
        
        
        initAndLayoutActivityIndicator()
        
    }
    
    func instantiateButtons() {
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
    
    
    // MARK: - Overlay export methods
    
    func exportWithOverlays(completion: @escaping (Bool) -> Void) {
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
        videoLayer.frame = CGRect(x: 80, y: 154, width: HDVideoSize.width * 0.78, height: HDVideoSize.height * 0.78)
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: HDVideoSize.width, height: HDVideoSize.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        if let text = topTextField.text, !topTextField.text!.isEmpty {
            // Text layer
            let topTextLayer = CATextLayer()
            topTextLayer.frame = CGRect(x: 40, y: 20, width: HDVideoSize.width - 40, height: HDVideoSize.height - 20)
            // Text attributes
            topTextLayer.string = text
            topTextLayer.font = CTFontCreateWithName(Font.nameForCard as CFString, 0.0, nil)
            topTextLayer.fontSize = Font.Size.cardVideo
            topTextLayer.foregroundColor = UIColor.white.cgColor
            topTextLayer.alignmentMode = kCAAlignmentLeft
            topTextLayer.backgroundColor = UIColor.clear.cgColor
            topTextLayer.contentsScale = 1
            topTextLayer.shadowColor = UIColor.black.cgColor
            topTextLayer.shadowOffset = CGSize(width: 4, height: 4)
            topTextLayer.shadowRadius = 0
            topTextLayer.shadowOpacity = 1
            parentLayer.addSublayer(topTextLayer)
        }
        
        if let text = bottomTextField.text, !bottomTextField.text!.isEmpty {
            // Text layer
            let bottomTextLayer = CATextLayer()
            bottomTextLayer.frame = CGRect(x: -20, y: -1145, width: HDVideoSize.width - 20, height: HDVideoSize.height)
            // Text attributes
            bottomTextLayer.string = text
            bottomTextLayer.font = CTFontCreateWithName(Font.nameForCard as CFString, 0.0, nil)
            bottomTextLayer.fontSize = Font.Size.cardVideo
            bottomTextLayer.foregroundColor = UIColor.white.cgColor
            bottomTextLayer.alignmentMode = kCAAlignmentRight
            bottomTextLayer.backgroundColor = UIColor.clear.cgColor
            bottomTextLayer.contentsScale = 1
            bottomTextLayer.shadowColor = UIColor.black.cgColor
            bottomTextLayer.shadowOffset = CGSize(width: 4, height: 4)
            bottomTextLayer.shadowRadius = 0
            bottomTextLayer.shadowOpacity = 1
            parentLayer.addSublayer(bottomTextLayer)
        }
        
        // Animation composition
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(1, 30)
        layercomposition.renderSize = HDVideoSize
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer:videoLayer, in: parentLayer)
        
        // Export instructions
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let layerInstr = videoCompositionInstructionForTrack(track: compositionVideoTrack, assetTrack: videoTrack)
        instruction.layerInstructions = [layerInstr]
        layercomposition.instructions = [instruction]
    
        // Export
        let filePath = NSTemporaryDirectory() + fileName()
        let movieUrl = URL(fileURLWithPath: filePath)
    
        guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPreset1280x720) else { return }
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
            playPauseButton.setImage(Icons.playButton, for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(Icons.pauseButton, for: .normal)
        }
    }
    
    // Alert
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
        saveButton.isHidden = true
        playPauseButton.isHidden = true
        exportWithOverlays { (success) in
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

// MARK: Handle keyboard notifications

extension EditCardViewController {
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if bottomTextField.isEditing {
                self.view.window?.frame.origin.y = -1 * keyboardHeight
            }
        }
        saveButton.isEnabled = false
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if self.view.window?.frame.origin.y != 0 {
                self.view.window?.frame.origin.y += keyboardHeight
            }
        }
        saveButton.isEnabled = true
    }
}

// MARK: - Text field delegate & methods

extension EditCardViewController: UITextFieldDelegate {
    func setupText() {
        let font = UIFont(name: Font.nameForCard, size: Font.Size.cardView)
        
        topTextField = UITextField()
        topTextField.delegate = self
        view.addSubview(topTextField)
        topTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(-4)
        }
        
        topTextField.text = "Enter some text"
        topTextField.font = font
        topTextField.textAlignment = .left
        topTextField.clearsOnBeginEditing = true
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
        
        view.addSubview(bottomTextField)
        bottomTextField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
        
        // Text attributes
        bottomTextField.text = "Enter some text"
        bottomTextField.font = font
        bottomTextField.textAlignment = .right
        bottomTextField.clearsOnBeginEditing = true
        bottomTextField.textColor = UIColor.white
        bottomTextField.backgroundColor = UIColor.clear
        // Text drop shadow
        bottomTextField.layer.shadowColor = UIColor.black.cgColor
        bottomTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
        bottomTextField.layer.shadowRadius = 0
        bottomTextField.layer.shadowOpacity = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 16
        let currentStr: NSString = textField.text! as NSString
        let newStr =
            currentStr.replacingCharacters(in: range, with: string) as NSString
        return newStr.length <= maxLength
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
