//
//  ContactsViewController.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/16/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContactsViewController: UIViewController {

    let ref = FIRDatabase.database().reference(withPath: "contacts")
    var user: User?
    var userUid: String?
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.userUid = user.uid
            print("Current logged in user email - \(self.user?.email)")
        })
        
        ref.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                for item in snapshot.children.allObjects {
                    self.contacts.append(Contact(snapshot: item as! FIRDataSnapshot))
                }
                print("Current contacts list contains:")
                dump(self.contacts)
            }
        })
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
