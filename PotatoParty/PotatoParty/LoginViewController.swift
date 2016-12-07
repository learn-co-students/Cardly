//
//  ViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Constraint constants
    
    let textFieldToSuperviewWidthMultiplier = 0.6
    let textFieldToSuperviewHeightMultiplier = 0.25
    let passwordTextFieldTopOffset = 40
    let loginButtonToTextFieldWidthMultipier = 1.0/3.0
    let loginButtonToTextFieldHeightMultiplier = 0.5
    let loginButtonTopOffset = 30
    let createAccountButtonTopOffset = 100
    let createAccountButtonWidthMultiplier = 0.8
    let forgotPasswordButtonTopOffset = 30

    var userTextfield = UITextField()
    var passwordTextfield = UITextField()
    var loginButton = UIButton()
    var createAccountButton = UIButton()
    var forgotPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViewAndContraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextfield {
            userTextfield.becomeFirstResponder()
        }
        if textField == passwordTextfield {
            textField.resignFirstResponder()
        }
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: - Firebase account methods

extension LoginViewController {
    
    func createAccountButtonTapped() {
        let destVC = CreateAccountViewController()
        destVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
        
//        let alertController = UIAlertController(title: "Create Account", message: "Create User Account", preferredStyle: .alert)
//
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
//            let emailField = alertController.textFields![0]
//            let passwordField = alertController.textFields![1]
//
//            if let unwrappedEmail = emailField.text, let unwrappedPassword = passwordField.text {
//                FIRAuth.auth()!.createUser(withEmail: unwrappedEmail, password: unwrappedPassword, completion: { (user, error) in
//                    if error == nil {
//                        self.firebaseSignIn(user: unwrappedEmail, password: unwrappedPassword)
//                    }
//                })
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        alertController.addAction(submitAction)
//        alertController.addAction(cancelAction)
//        alertController.addTextField { (textfield) in
//            textfield.placeholder = "Enter e-mail"
//        }
//        alertController.addTextField { (textfield) in
//            textfield.placeholder = "Enter password"
//        }
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginButtonTapped() {
        firebaseSignIn(user: userTextfield.text!, password: passwordTextfield.text!)
    }
    
    func firebaseSignIn(user: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: user, password: password, completion: { (user, error) in
            if error == nil {
                self.loginSuccessSegue()
            }
            else {
                print("Firebase sign in error: \(error?.localizedDescription)")
                let alertController = UIAlertController(title: "Error", message: "Email or Password is incorrect", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


// MARK: - Navigation methods

extension LoginViewController {
    
    func loginSuccessSegue() {
        let initialVC = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: initialVC)
        present(navigationController, animated: true, completion: nil)
    }

}

