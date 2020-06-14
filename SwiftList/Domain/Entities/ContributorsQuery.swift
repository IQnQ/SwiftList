//
//  ContributorsQuery.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 14..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct ContributorsQuery {
    let owner: String
    let repoName: String
    
}

extension ContributorsQuery: Equatable {}
