//
//  RepositoryQuery.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct RepositoryQuery {
    let query: String
}

extension RepositoryQuery: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
    }
}
