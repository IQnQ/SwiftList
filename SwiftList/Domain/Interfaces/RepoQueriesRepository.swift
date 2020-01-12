//
//  RepoQueriesRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol RepoQueriesRepository {
    func recentsQueries(number: Int, completion: @escaping (Result<[RepositoryQuery], Error>) -> Void)
    func saveRecentQuery(query: RepositoryQuery, completion: @escaping (Result<RepositoryQuery, Error>) -> Void)
}
