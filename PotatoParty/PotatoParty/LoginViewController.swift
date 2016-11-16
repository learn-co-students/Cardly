//
//  ViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import SnapKit

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
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: nil)
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

