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

    var userTextfield = UITextField()
    var passwordTextfield = UITextField()
    var loginButton = UIButton()
    var createAccountButton = UIButton()
    var forgotPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViewAndContraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: - Create user account

extension LoginViewController {
    
    func createAccountButtonTapped() {
        let alertController = UIAlertController(title: "Create Account", message: "Create User Account", preferredStyle: .alert)

        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            let emailField = alertController.textFields![0]
            let passwordField = alertController.textFields![1]
            if let unwrappedEmail = emailField.text, let unwrappedPassword = passwordField.text {
                FIRAuth.auth()!.createUser(withEmail: unwrappedEmail, password: unwrappedPassword, completion: { (user, error) in
                    if error == nil {
                        FIRAuth.auth()!.signIn(withEmail: self.userTextfield.text!, password: self.passwordTextfield.text!)
                    }
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter e-mail"
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter password"
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

