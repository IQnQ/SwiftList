//
//  RepoListItemViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol RepoListItemViewModelInput { }

protocol RepoListItemViewModelOutput {
    var repo: Repository { get }
}

protocol RepoListItemViewModel: RepoListItemViewModelInput, RepoListItemViewModelOutput { }

final class DefaultRepoListItemViewModel: RepoListItemViewModel {
    
    private(set) var id: RepoId

    // MARK: - OUTPUT
    let repo: Repository

    init(repo: Repository) {
        self.repo = repo
        self.id = repo.id
    }
}

func == (lhs: DefaultRepoListItemViewModel, rhs: DefaultRepoListItemViewModel) -> Bool {
    return (lhs.id == rhs.id)
}
