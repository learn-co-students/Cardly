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
    
    var logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

}


