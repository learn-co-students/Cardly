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

