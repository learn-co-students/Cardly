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

}
