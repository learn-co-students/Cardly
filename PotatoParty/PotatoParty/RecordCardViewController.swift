//
//  RecordCardViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices

class RecordCardViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = startCameraFromViewController(self, withDelegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = true //allow video editing
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension RecordCardViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            guard let unwrappedURL = info[UIImagePickerControllerMediaURL] as? URL else { return }
            let path = unwrappedURL.path
            print("video path is \(path)")
        
        // Pass video to edit video viewcontroller
        let editVideoVC = EditCardViewController()
        editVideoVC.fileLocation = unwrappedURL
        navigationController?.pushViewController(editVideoVC, animated: true)
//            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
//                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(RecordCardViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
//            }
        }
    }
    
}

// MARK: - UINavigationControllerDelegate

extension RecordCardViewController: UINavigationControllerDelegate {
    
}
