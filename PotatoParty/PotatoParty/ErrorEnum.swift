//
//  ErrorEnum.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 12/11/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//

import Foundation

enum UserError: String, Error {
    case NoCurrentUser = "Cannot find current user"
}
