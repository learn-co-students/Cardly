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
import Whisper

protocol ModalViewControllerDelegate {
    func modalViewControllerDidDisappear(completion: @escaping () -> Void)
}

class SendCardViewController: UIViewController {
    
    static let assetKeysRequiredToPlay = ["playable", "hasProtectedContent"]

    var sendEmail = UIButton()
    var sendText = UIButton()
    var cancelButton = UIButton()
    var buttonStackView: UIStackView!
    var shared = User.shared
    var uid = FIRAuth.auth()?.currentUser?.uid
    let player = AVPlayer()
    var delegate: EditCardViewController?
    
    var fileLocation: URL? {
        didSet {
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        layoutElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        
        buttonStackView = UIStackView()
        view.addSubview(buttonStackView)
        buttonStackView.backgroundColor = UIColor.red
        buttonStackView.distribution = .fillEqually
        buttonStackView.snp.makeConstraints { (make) in
            make.topMargin.equalTo(playerView.snp.bottomMargin)
            make.leading.equalTo(playerView.snp.leadingMargin)
            make.trailing.equalTo(playerView.snp.trailingMargin)
            make.height.equalTo(playerView.snp.width).dividedBy(3)
        }
        
        buttonStackView.addArrangedSubview(sendEmail)
        sendEmail.setImage(Icons.sendEmailIcon, for: .normal)
        sendEmail.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(sendText)
        sendText.setImage(Icons.sendTextIcon, for: .normal)
        sendText.addTarget(self, action: #selector(sendTextButtonTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(cancelButton)
        cancelButton.setImage(Icons.cancelIcon, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }
    
    // MARK: - Email and Message integration methods
    
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
            
            guard let fileLocation = fileLocation else {
                fatalError("File location does not exist!")
            }
            message.addAttachmentURL(fileLocation, withAlternateFilename: nil)
            message.body = "Thank You so much!"
            
            DispatchQueue.main.async {
                self.present(message, animated: true, completion: nil)
            }
            
        } else {
            let noTextAlertVC = UIAlertController(title: "Unable to send text", message: "Please check your account settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            noTextAlertVC.addAction(okAction)
            present(noTextAlertVC, animated: true, completion: nil)
            print("error: Text compose view controller cannot send mail")
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
            if let currentUserEmail = FIRAuth.auth()?.currentUser?.email {
                mail.setToRecipients([currentUserEmail])
            }
            mail.setSubject("Thank You Video")
            guard let fileLocation = fileLocation else {
                fatalError("File location does not exist!")
            }
            let data = NSData(contentsOf: fileLocation )
            guard let unwrappedData = data else { return }
            mail.addAttachmentData(unwrappedData as Data, mimeType: "MOV", fileName: "Thank_You_Video.MOV")
            mail.setMessageBody("<p>You're so awesome! <p>", isHTML: true)
            
            DispatchQueue.main.async {
                self.present(mail, animated: true)
            }
            
        } else {
            let noEmailAlertVC = UIAlertController(title: "No mail account found", message: "Please set up an account in order to send email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            noEmailAlertVC.addAction(okAction)
            present(noEmailAlertVC, animated: true, completion: nil)
            print("error: MAIL compose view controller cannot send mail")
        }
        
    }
    
    func videoWasSent(completion:() -> ()) {
        
        for contactIndex in shared.selectedContacts.indices {
            shared.selectedContacts[contactIndex].is_sent = true
            print("was video sent: \(shared.selectedContacts[contactIndex].is_sent)")
            let contactsRef = FIRDatabase.database().reference(withPath: "contacts")
            let userContactsRef = contactsRef.child("\(uid)/all/\(shared.selectedContacts[contactIndex].key)/is_sent")
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
        delegate?.modalViewControllerDidDisappear(completion: {
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

// MARK: - Email/Message framework delegate methods

extension SendCardViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .sent:
            videoWasSent {
                shared.selectedContacts.removeAll()
            }
            controller.dismiss(animated: true, completion: {
                self.delegate?.modalViewControllerDidDisappear(completion: {
                    self.clearTmpDirectory()
                })
            })
            CustomNotification.show("E-mail sent successfully")
        case .failed:
            if error != nil {
                presentGenericErrorAlert()
            } else {
                print("Error sending email")
            }  
        default:
            controller.dismiss(animated: true)
        }
    }

}

extension SendCardViewController: MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            videoWasSent {
                shared.selectedContacts.removeAll()
            }
            controller.dismiss(animated: true, completion: {
                self.delegate?.modalViewControllerDidDisappear(completion: {
                    self.clearTmpDirectory()
                })
            })
            CustomNotification.show("Text sent successfully")
        case .failed:
            presentGenericErrorAlert()
        default:
            controller.dismiss(animated: true)
        }
    }
    
}

extension SendCardViewController {
    
    func presentGenericErrorAlert() {
        let errorAC = UIAlertController(title: "Error", message: "An unexpected error occured, please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        errorAC.addAction(okAction)
        present(errorAC, animated: true, completion: nil)
    }
    
}
