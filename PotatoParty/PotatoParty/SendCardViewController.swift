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

class SendCardViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var sendEmail = UIButton()
    
    
    
    func layoutElements() {
    view.addSubview(sendEmail)
    sendEmail.snp.makeConstraints { (make) in
    make.centerX.equalToSuperview()
    make.centerY.equalToSuperview()
    make.width.equalTo(view.snp.width).multipliedBy(0.25)
    make.height.equalTo(view.snp.height).multipliedBy(0.25)
    }
    
        sendEmail.backgroundColor = UIColor.blue
        sendEmail.titleLabel?.text = "SEND E-MAIL"
        sendEmail.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
    }
    
    func sendEmailButtonTapped(){
        print("send e-mail button tapped")
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["arielaades@gmail.com"])
            mail.setSubject("Thank You Video")
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/potatoparty-9ac99.appspot.com/o/Videos%2FIMG_4278.MOV?alt=media&token=e357c274-d2d0-460d-87fe-84840eb70ec3")
            let type = "mov"
            let height = "200"
            let width = "100"
            let controls = "controls"
            let name = "IMG_4278.MOV"
            
            guard let downloadURL = url else { return }
            mail.setMessageBody("<p>You're so awesome! <p>You've received a Video!&nbsp;</p><p><a href=\(downloadURL)>Click Here to See your Video hyperlink</a></p></p><video controls=\(controls)width=\(width) height=\(height) name=\(name) src=\(downloadURL)></video> <p> <p>&nbsp;</p> <p>Love,&nbsp;</p> <p>&nbsp;</p><p>The M </p>", isHTML: true)
            
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("error: MAIL compose view controller can NOT send mail")
        }
        
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
