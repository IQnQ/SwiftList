//
//  DefaultRepoQueriesRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class DefaultRepoQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var repoQueriesPersistentStorage: RepoQueriesStorage
    
    init(dataTransferService: DataTransferService,
         repoQueriesPersistentStorage: RepoQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.repoQueriesPersistentStorage = repoQueriesPersistentStorage
    }
}

extension DefaultRepoQueriesRepository: RepoQueriesRepository {
    
    func recentsQueries(number: Int, completion: @escaping (Result<[RepositoryQuery], Error>) -> Void) {
        return repoQueriesPersistentStorage.recentsQueries(number: number, completion: completion)
    }
    
    func saveRecentQuery(query: RepositoryQuery, completion: @escaping (Result<RepositoryQuery, Error>) -> Void) {
        repoQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
