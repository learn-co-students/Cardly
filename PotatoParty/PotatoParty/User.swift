//
//  User.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    static let shared = User()
    
    let groups: [String] = ["All", "Family", "Friends", "Coworkers", "Other"]
    var selectedContacts = [Contact]()
    var contacts: [Contact] = []

    private init() { }
}
