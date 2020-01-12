//
//  Owner.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

typealias OwnerId = String

struct Owner {
    let id: OwnerId
    let login: String
    let avatar: String?
}
