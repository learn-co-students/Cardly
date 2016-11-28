//
//  SendCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseStorage
import SnapKit

class SendCardViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
   
    var sendEmail = UIButton()
    var sendText = UIButton()
    var videoURL: URL!
    var shared = User.shared
    
    func layoutElements() {
        view.addSubview(sendEmail)
        sendEmail.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(20)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
    
        sendEmail.backgroundColor = UIColor.blue
        sendEmail.setTitle("SEND E-MAIL", for: .normal)
        sendEmail.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
        
        view.addSubview(sendText)
        sendText.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.topMargin.equalTo(sendEmail.snp.bottomMargin).offset(0.5)
            make.width.equalTo(sendEmail)
            make.height.equalTo(sendEmail)
        }
        
        sendText.backgroundColor = UIColor.blue
        sendText.setTitle("SEND TEXT", for: .normal)
        sendText.addTarget(self, action: #selector(sendTextButtonTapped), for: .touchUpInside)
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
            shared.selectedContacts.removeAll()
        } else {
            print("error: MAIL compose view controller canNOT send mail")
        }
    }
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
        print("dismiss compose mail controller")
        successSent()
        
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
            
            //if we go the route of embedding in html:
            //            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/potatoparty-9ac99.appspot.com/o/Videos%2FIMG_4278.MOV?alt=media&token=e357c274-d2d0-460d-87fe-84840eb70ec3")
            //            let type = "mov"
            //            let height = "200"
            //            let width = "100"
            //            let controls = "controls"
            //            let name = "IMG_4278.MOV"
            //            mail.setMessageBody("<p>You're so awesome! <p>You've received a Video!&nbsp;</p><p><a href=\(unwrappedVideoURL)>Click Here to See your Video hyperlink</a></p></p><video controls=\(controls)width=\(width) height=\(height) name=\(name) src=\(unwrappedVideoURL)></video> <p> <p>&nbsp;</p> <p>Love,&nbsp;</p> <p>&nbsp;</p><p>The M </p>", isHTML: true)
            
            present(mail, animated: true)
            shared.selectedContacts.removeAll()
            
        } else {
            // show failure alert
            print("error: MAIL compose view controller canNOT send mail")
        }
        
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        print("dismiss compose mail controller")
        successSent()
    }
    
    //Let user know e-mail was sent successfully - alert controller? 
    func successSent() {
        print("You've sent your video successfully")
    }
    
    //PULLING VIDEO FROM FIREBASE _ FOR TESTING
    
//    func downloadVideoURL() {
//        let storage = FIRStorage.storage()
//        let videoRef = storage.reference(forURL: "gs://potatoparty-9ac99.appspot.com")
//        let metaData = FIRStorageMetadata()
//        metaData.contentType = "video/quicktime"
//        let url = videoRef.child("Video").child("IMG_4278.MOV")
//        let task = url.put(url, metadata: nil) { (metadata, error) in
//            if (error != nil) {
//                print("got an error: \(error)")
//            } else {
//                print ("upload complete! HEre's some metadata: \(metadata)")
//                print ("donwload URL is \(metadata.downloadURL())")
//            let downloadURL = metaData.downloadURL()?.absoluteString
//
//            }
//        }
//    }
    
   
    
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
//        if let unwrappedVideoURL = videoURL {
//            print("Passed video url is \(unwrappedVideoURL)")
//        }
//        else {
//            print("Video url is nil!!!!")
//        }
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
