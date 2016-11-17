//
//  User.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
