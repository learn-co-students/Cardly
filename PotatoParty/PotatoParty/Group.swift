//
//  Group.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Group {
    
    let key: String
    let name: String
    let ref: FIRDatabaseReference?
    
    init(name: String, key: String = "") {
        self.name = name
        self.key = key
        ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
    }
    
    func toAny() -> Any {
        return [
            "name": name
        ]
    }
    
}
