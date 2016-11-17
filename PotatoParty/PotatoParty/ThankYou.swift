//
//  ThankYou.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/17/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ThankYou {
    
    let key: String
    let videoUrl: String
    let creator_key: String
    let ref: FIRDatabaseReference?
    
    init(videoUrl: String, creator_key: String, key: String = "") {
        self.videoUrl = videoUrl
        self.creator_key = creator_key
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        videoUrl = snapshotValue["videoUrl"] as! String
        creator_key = snapshotValue["creator_key"] as! String
        ref = snapshot.ref
    }
    
    func toAny() -> Any {
        return [
            "videoUrl": videoUrl,
            "creator_key": creator_key,
        ]
    }
    
}
