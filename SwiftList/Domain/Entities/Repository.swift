//
//  Repository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct RepositoriesPage {
    let totalRepos: Int
    let repos: [Repository]
}

typealias RepoId = String

struct Repository {
    let id: RepoId
    let name: String
    let fullName: String
    let owner: Owner
    let size: Int
    let forks: Int
    let stars: Int
}
