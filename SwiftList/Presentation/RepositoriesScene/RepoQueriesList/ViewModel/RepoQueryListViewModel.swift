//
//  RepoQueryListViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol RepoQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: RepoQueryListItemViewModel)
}

protocol RepoQueryListViewModelOutput {
    var items: Observable<[RepoQueryListItemViewModel]> { get }
}

protocol RepoQueryListViewModel: RepoQueryListViewModelInput, RepoQueryListViewModelOutput { }

protocol RepoQueryListViewModelDelegate: class {
    
    func repoQueriesListDidSelect(repoQuery: RepositoryQuery)
}

final class DefaultRepoQueryListViewModel: RepoQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentRepoQueriesUseCase: FetchRecentRepoQueriesUseCase
    private weak var delegate: RepoQueryListViewModelDelegate?
    
    // MARK: - OUTPUT
    let items: Observable<[RepoQueryListItemViewModel]> = Observable([])
    
    init(numberOfQueriesToShow: Int,
         fetchRecentRepoQueriesUseCase: FetchRecentRepoQueriesUseCase,
         delegate: RepoQueryListViewModelDelegate? = nil) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentRepoQueriesUseCase = fetchRecentRepoQueriesUseCase
        self.delegate = delegate
    }
    
    private func updateRepoQueries() {
        let request = FetchRecentRepoQueriesUseCaseRequestValue(number: numberOfQueriesToShow)
        _ = fetchRecentRepoQueriesUseCase.execute(requestValue: request) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items.value = items.map { $0.query }.map ( DefaultRepoQueryListItemViewModel.init )
            case .failure: break
            }
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultRepoQueryListViewModel {
        
    func viewWillAppear() {
        updateRepoQueries()
    }
    
    func didSelect(item: RepoQueryListItemViewModel) {
        delegate?.repoQueriesListDidSelect(repoQuery: RepositoryQuery(query: item.query))
    }
}
