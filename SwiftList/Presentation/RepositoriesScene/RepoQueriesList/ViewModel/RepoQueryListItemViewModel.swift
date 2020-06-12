//
//  RepoQueryListItemViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol RepoQueryListItemViewModelInput { }

protocol RepoQueryListItemViewModelOutput {
    var query: String { get }
}

protocol RepoQueryListItemViewModel: RepoQueryListItemViewModelInput, RepoQueryListItemViewModelOutput { }

final class DefaultRepoQueryListItemViewModel: RepoQueryListItemViewModel, Equatable {
    let query: String
    
    init(query: String) {
        self.query = query

    }
}

func == (lhs: DefaultRepoQueryListItemViewModel, rhs: DefaultRepoQueryListItemViewModel) -> Bool {
    return (lhs.query == rhs.query)
}
