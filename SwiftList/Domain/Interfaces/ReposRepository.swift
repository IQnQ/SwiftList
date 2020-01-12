//
//  ReposRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol ReposRepository {
    @discardableResult
    func reposList(query: RepositoryQuery, page: Int, completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable?
}
