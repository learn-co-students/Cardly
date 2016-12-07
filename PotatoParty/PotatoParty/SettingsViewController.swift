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
    var changeEmailButton: UIButton!
    var changePasswordButton: UIButton!
    var logoutButton: UIButton!
    var forgotPasswordButton: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    // Textfields
    var newEmailTextField: UITextField!
    var confirmNewEmailTextField: UITextField!
    var currentPasswordTextField: UITextField!
    var newPasswordTextField: UITextField!
    var confirmNewPasswordTextField: UITextField!
    
    // validate textfield content
    var email: String?
    var password: String?
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false
    var isCurrentPasswordValid: Bool = false
    var isConfirmPasswordValid: Bool = false
    
    let currentUser = FIRAuth.auth()?.currentUser
    
    //  var settingsBackgroundImage: UIImage = #imageLiteral(resourceName: "contactsAndSettingsVCBackgroundImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
        registerForKeyboardNotifications()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
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
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    // MARK - Textfield aimations
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        attemptEmailChange()
    }
    
    
    func changePasswordButtonTapped(_sender: UIButton) {
        attemptPasswordChange()
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

// MARK: - Settings Animation

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

// MARK: - UITextField delegate methods

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case newEmailTextField:
//            if !validateEmail(text: newEmailTextField.text!){
//                isEmailValid = false
//            }
//            else{
//                isEmailValid = true
//            }
            validateEmail(text: textField.text!)
            break
        case currentPasswordTextField:
            isCurrentPasswordValid = validateCurrentPassword(password: textField.text!)
            break
        case newPasswordTextField:
            if !validateNewPassword(text: textField.text!){
                isPasswordValid = false
            }
            else{
                isPasswordValid = true
            }
            break
        case confirmNewPasswordTextField:
            if !validatePasswordConfirm(text: textField.text!){
                isConfirmPasswordValid = false
            }
            else{
                isConfirmPasswordValid = true
            }
            break
        default:
            break
        }
    }
}

// MARK: - Form field validation helpers

extension SettingsViewController {
    
    func validateEmail(text: String) {
        if !(text.characters.count > 0) {
            //show cannot be empty error
            changeEmailButton.isEnabled = false
            print("Email cannot be empty!")
        }
        if text.contains("@") && text.contains(".") {
            email = text
            changeEmailButton.isEnabled = true
        }
        else {
            changeEmailButton.isEnabled = false
        }
    }
    
    func validateCurrentPassword(password: String) -> Bool {
        if !(password.characters.count > 0) {
            //show cannot be empty error
            print("Current password cannot be empty")
            return false
        }
        return true
    }
    
    func validateNewPassword(text: String) -> Bool {
        if !(password!.characters.count > 0) {
            //show cannot be empty error
            print("New password cannot by empty")
        }
        if text.characters.count >= 6{
            password = text
            return true
        }
        return false
    }
    
    func validatePasswordConfirm(text: String) -> Bool {
        if !(password!.characters.count > 0) {
            print("Confirm password cannot be empty!")
            //show cannot be empty error
            return false
        }
        if let password = password {
            return text == password
        }
        return false
    }
    
    func checkIfPasswordFieldsValid(){
        if isCurrentPasswordValid && isPasswordValid && isConfirmPasswordValid {
            changePasswordButton.isEnabled = true
            print("change password button enabled")
        }
        else{
            changePasswordButton.isEnabled = false
            print("change password button disabled")
        }
    }
    
    //call this function when submit button for password is clicked
    func attemptPasswordChange() {
        if let password = password, password.characters.count > 0{
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: (currentUser?.email)!, password: password)
            currentUser?.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    //display invalid authentication error
                }
                else { //attempt to change password
                    self.currentUser?.updatePassword(self.newPasswordTextField.text!, completion: { (error) in
                        if error != nil {
                            //show change password error
                            print("Failed to update password!")
                        }
                        else {
                            //show success error
                            print("Password update success!")
                        }
                    })
                }
            })
        }
        else{
            //display no password entered error
            print("No password entered!")
        }
        
    }
    
    func attemptEmailChange() {
        if let email = email {
            currentUser?.updateEmail(email, completion: { (error) in
                if error != nil {
                    print("Unable to change email")
                    //show change email error
                }
                else {
                    print("Successfully changed email!")
                    //show email success
                }
            })
        }
    }

}

// MARK: - Keyboard methods

extension SettingsViewController {
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if newPasswordTextField.isEditing || confirmNewPasswordTextField.isEditing {
                self.view.window?.frame.origin.y = -1 * keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if self.view.window?.frame.origin.y != 0 {
                self.view.window?.frame.origin.y += keyboardHeight
            }
        }
    }
}

// MARK: - Tap gesture methods

extension SettingsViewController {
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


