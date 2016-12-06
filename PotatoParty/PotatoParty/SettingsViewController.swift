//
//  SettingsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    // Buttons
    var changeEmailButton = UIButton()
    var changePasswordButton = UIButton()
    var logoutButton = UIButton()
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    // Textfields
    var newEmailTextField: UITextField!
    var newEmailLabel: UILabel!
    let newEmailText: String = "New Email Address"
    var currentPasswordTextField: UITextField!
    var currentPasswordLabel: UILabel!
    var currentPasswordText: String = "Current Password"
    var newPasswordTextField: UITextField!
    var newPasswordLabel: UILabel!
    var newPasswordText: String = "New Password"
    var confirmNewPasswordTextField: UITextField!
    var confirmNewPasswordLabel: UILabel!
    var confirmNewPasswordText = "Confirm New Password"
    
    
    //  var settingsBackgroundImage: UIImage = #imageLiteral(resourceName: "contactsAndSettingsVCBackgroundImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutElements()
        
        let closeBtn = UIButton()
        self.view.addSubview(closeBtn)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(35)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
        //        dismissButton = {
        //            let button = UIButton(frame: .zero)
        //            button.setImage(UIImage(named: "ic_menu"), for: .normal)
        //            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        //            return button
        //        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = ""
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
    }
    
    // MARK - Textfield aimations
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        newEmailTextField.isHidden = false
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .transitionCurlDown, animations: {
                self.newEmailTextField.center.x = self.view.bounds.width * 0.5
            }) { (success) in
                
        }
        
        currentPasswordTextField.isHidden = false
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseIn, animations: {
            self.currentPasswordTextField.center.x = self.view.bounds.width * 0.5
        }) { (success) in
            
        }
        
        newPasswordTextField.isHidden = false
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .transitionCrossDissolve, animations: {
            self.newPasswordTextField.center.x = self.view.bounds.width * 0.5
            
        }) { (success) in
            
        }
        
        
        confirmNewPasswordTextField.isHidden = false
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .transitionCrossDissolve, animations: {
            self.confirmNewPasswordTextField.center.x = self.view.bounds.width * 0.5
        }) { (success) in
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Background Methods
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    // MARK - Button Methods
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            present(LoginViewController(), animated: true, completion: {
                self.navigationController?.viewControllers.removeAll()
            })
        } catch {
            print("Logout error = (error.localizedDescription)")
        }
    }
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    func changeEmailButtonTapped(_sender: UIButton) {
        // TO DO
        
    }
    
    
    func changePasswordButtonTapped(_sender: UIButton) {
        // TO DO
        
    }
    
    
    // MARK - Textfield Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //Color #2 - While selecting the text field
        view.backgroundColor = UIColor.purple
    }
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //Color #3 - While touching outside the textField.
        view.backgroundColor = UIColor.cyan
        
        //Hide the keyboard
        newEmailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Display the result.
        //      newEmailLabel.text = str+textField.text
        
        //Color #4 - After pressing the return button
        view.backgroundColor = UIColor.orange
        
        newEmailTextField.resignFirstResponder() //Hide the keyboard
        return true
    }
    
}

// MARK - Settings Animation

extension SettingsViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
    
}


