//
//  Contributor.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct ContributorsPage {
    let contributors: [Contributor]
}

typealias ContriId = String

struct Contributor {
    let id: ContriId
    let login: String
    let avatar: String?
}
