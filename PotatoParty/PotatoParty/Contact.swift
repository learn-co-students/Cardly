//
//  ContactModels.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

final class Contact {
    
    
    let key: String
    let fullName: String
    let email: String
    let phone: String
    let photoUrl: String
    var is_sent: Bool
    var group_key: String
    let ref: FIRDatabaseReference?
    var isChosen: Bool = false
    
    init(fullName: String, email: String, phone: String, is_sent: Bool = false, key: String = "", group_key: String = "", photoUrl: String = "") {
        self.key = key
        self.group_key = group_key
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.is_sent = is_sent
        self.ref = nil
        self.photoUrl = photoUrl
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        fullName = snapshotValue["fullName"] as! String
        email = snapshotValue["email"] as! String
        phone = snapshotValue["phone"] as! String
        is_sent = snapshotValue["is_sent"] as! Bool
        group_key = snapshotValue["group_key"] as! String
        photoUrl = snapshotValue["photoUrl"] as! String
        ref = snapshot.ref
    }
    
    func toAny() -> Any {
        return [
            "fullName": fullName,
            "email" : email,
            "phone" : phone,
            "photoUrl": photoUrl,
            "is_sent": is_sent,
            "group_key": group_key,
            
        ]
    }
}
