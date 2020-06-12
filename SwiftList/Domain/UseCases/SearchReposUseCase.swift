//
//  SearchReposUseCase.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol SearchReposUseCase {
    func execute(requestValue: SearchReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchReposUseCase: SearchReposUseCase {
    
    private let repoQueriesRepository: RepoQueriesRepository
    
    init(repoQueriesRepository: RepoQueriesRepository) {
        self.repoQueriesRepository = repoQueriesRepository
    }
    
    func execute(requestValue: SearchReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable? {
        return repoQueriesRepository.searchQuery(query: requestValue.query, page: requestValue.page) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                strongSelf.repoQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

struct SearchReposUseCaseRequestValue {
    let query: RepositoryQuery
    let page: Int
}
