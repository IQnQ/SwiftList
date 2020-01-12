//
//  RepoListItemViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol RepoListItemViewModel {
    var name: String { get }
    var fullName: String { get }
    var owner: Owner { get }
    var size: Int { get }
    var stars: Int { get }
    var forks: Int { get }
}


final class DefaultRepoListItemViewModel: RepoListItemViewModel {
    
    private(set) var id: RepoId

    // MARK: - OUTPUT
    let name: String
    let fullName: String
    let owner: Owner
    let size: Int
    let stars: Int
    let forks: Int

    init(repo: Repository) {
        self.id = repo.id
        self.name = repo.name
        self.fullName = repo.fullName
        self.owner = repo.owner
        self.size = repo.size
        self.stars = repo.stars
        self.forks = repo.forks
    }
}

func == (lhs: DefaultRepoListItemViewModel, rhs: DefaultRepoListItemViewModel) -> Bool {
    return (lhs.id == rhs.id)
}
