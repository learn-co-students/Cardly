//
//  SendCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseStorage
import SnapKit
import AVFoundation

protocol ModalViewControllerDelegate {
    func modalViewControllerDidCancel(completion: @escaping () -> Void)
}

class SendCardViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]

    var sendEmail = UIButton()
    var sendText = UIButton()
    var cancelButton = UIButton()
    var videoURL: URL!
    var shared = User.shared
    let player = AVPlayer()
    var delegate: EditCardViewController?
    
    var fileLocation: URL? {
        didSet {
            print("set file location is \(fileLocation)")
            asset = AVURLAsset(url: fileLocation!)
        }
    }
    
    var playerView = PlayerView()
    
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
            player.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        layoutElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - View layout
    
    func layoutElements() {
        
        view.addSubview(playerView)
        playerView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.topMargin.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }
        playerView.backgroundColor = UIColor.clear
        playerView.playerLayer.frame = playerView.bounds
        playerView.layer.masksToBounds = true
        playerView.layer.cornerRadius = 10
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 0.8
        playerView.layer.shadowOffset = CGSize.zero
        playerView.layer.shadowRadius = 30
        view.sendSubview(toBack: playerView)
        
        playerView.playerLayer.player = player
        
        view.addSubview(sendEmail)
        sendEmail.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(playerView.snp.leadingMargin)
            make.topMargin.equalTo(playerView.snp.bottomMargin).offset(20)
            make.width.equalTo(playerView.snp.width).multipliedBy(1.0/3.0).offset(5)
            make.height.equalTo(40)
        }
    
        sendEmail.backgroundColor = UIColor.blue
        sendEmail.setTitle("E-MAIL", for: .normal)
        sendEmail.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
        
        view.addSubview(sendText)
        sendText.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(sendEmail.snp.trailingMargin)
            make.topMargin.equalTo(playerView.snp.bottomMargin).offset(20)
            make.width.equalTo(sendEmail)
            make.height.equalTo(sendEmail)
        }
        sendText.backgroundColor = UIColor.blue
        sendText.setTitle("TEXT", for: .normal)
        sendText.addTarget(self, action: #selector(sendTextButtonTapped), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(sendText.snp.trailingMargin)
            make.topMargin.equalTo(playerView.snp.bottomMargin).offset(20)
            make.width.equalTo(sendEmail)
            make.height.equalTo(sendEmail)
        }
        cancelButton.backgroundColor = UIColor.blue
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        

        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }
    
    // MARK: - Email and Message integration methods
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            videoWasSent {
                shared.selectedContacts.removeAll()
            }
            controller.dismiss(animated: true)
            let destVC = ContactsViewController()
            navigationController?.pushViewController(destVC, animated: true)
        default:
            controller.dismiss(animated: true)
        }
    }
    
    func sendTextButtonTapped() {
        
        if MFMessageComposeViewController.canSendText() && MFMessageComposeViewController.canSendAttachments()  {
            
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self
            var phoneNumberArray: [String] = []
            for contact in shared.selectedContacts {
                let phoneNumber = contact.phone
                phoneNumberArray.append(phoneNumber)
            }
            message.recipients = phoneNumberArray
            print("phone number array: \(phoneNumberArray)")
            message.subject = "Thank You Video"
            
            message.addAttachmentURL(videoURL, withAlternateFilename: nil)
            message.body = "Thank You so much!"
            
            present(message, animated: true, completion: nil)
            
        } else {
            print("error: MAIL compose view controller canNOT send mail")
        }
    }
    
    func sendEmailButtonTapped(){
        print("send e-mail button tapped")
        print("selected contacts: \(shared.selectedContacts)")
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            var emailArray: [String] = []
            for contact in shared.selectedContacts {
                
                let email = contact.email
                emailArray.append(email)
            }
            mail.setBccRecipients(emailArray)
            //insert user's e-mail in the "TO" field instead of arielaades@gmail.com
            mail.setToRecipients(["arielaades@gmail.com"])
            mail.setSubject("Thank You Video")
            let data = NSData(contentsOf: videoURL )
            guard let unwrappedData = data else { return }
            mail.addAttachmentData(unwrappedData as Data, mimeType: "MOV", fileName: "50161176453__6435040D-0DF3-426D-8A73-122E678A3663.MOV")
            mail.setMessageBody("<p>You're so awesome! <p>", isHTML: true)
            
            present(mail, animated: true)
            
        } else {
            // show failure alert
            print("error: MAIL compose view controller canNOT send mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .sent:
            videoWasSent {
                shared.selectedContacts.removeAll()
            }
            controller.dismiss(animated: true)
            let destVC = ContactsViewController()
            navigationController?.pushViewController(destVC, animated: true)
        default:
            controller.dismiss(animated: true)
        }
    }
    
    func videoWasSent(completion:() -> ()) {
        
        for contactIndex in shared.selectedContacts.indices {
            shared.selectedContacts[contactIndex].is_sent = true
            print("was video sent: \(shared.selectedContacts[contactIndex].is_sent)")
            
            
            let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
            let userContactsRef = contactsRef.child("\(User.shared.uid)/all/\(shared.selectedContacts[contactIndex].key)/is_sent")
            
            userContactsRef.setValue(true)
        }
        completion()
    }
    
    // MARK: - Helper methods
    
    func playerReachedEnd(notification: NSNotification) {
        asset = AVURLAsset(url: fileLocation!)
    }
    
    func loadURLAsset(_ asset: AVURLAsset) {
        asset.loadValuesAsynchronously(forKeys: SendCardViewController.assetKeysRequiredToPlay, completionHandler: {
            
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
    
    func cancelButtonTapped() {
        delegate?.modalViewControllerDidCancel(completion: {
            self.clearTmpDirectory()
        })
    }
    
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach { file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try FileManager.default.removeItem(atPath: path)
            }
        } catch {
            print("Error clearing tmp cache \(error.localizedDescription)")
        }
    }
}
