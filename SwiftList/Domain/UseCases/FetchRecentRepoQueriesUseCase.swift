//
//  FetchRecentRepoQueriesUseCase.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol FetchRecentRepoQueriesUseCase {
    func execute(requestValue: FetchRecentRepoQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[RepositoryQuery], Error>) -> Void) -> Cancellable?
}

final class DefaultFetchRecentRepoQueriesUseCase: FetchRecentRepoQueriesUseCase {
    
    private let repoQueriesRepository: RepoQueriesRepository
    
    init(repoQueriesRepository: RepoQueriesRepository) {
        self.repoQueriesRepository = repoQueriesRepository
    }
    
    func execute(requestValue: FetchRecentRepoQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[RepositoryQuery], Error>) -> Void) -> Cancellable? {
        repoQueriesRepository.recentsQueries(number: requestValue.number, completion: completion)
        return nil
    }
}

struct FetchRecentRepoQueriesUseCaseRequestValue {
    let number: Int
}
