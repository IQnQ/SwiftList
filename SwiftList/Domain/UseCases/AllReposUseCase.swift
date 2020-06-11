//
//  AllReposUseCase.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol AllReposUseCase {
    func execute(requestValue: AllReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultAllReposUseCase: AllReposUseCase {
    
    private let reposRepository: ReposRepository
    
    init(reposRepository: ReposRepository) {
        self.reposRepository = reposRepository
    }
    
    func execute(requestValue: AllReposUseCaseRequestValue,
                 completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable? {
        return reposRepository.reposList(page: requestValue.page, completion: completion)
    }
}

struct AllReposUseCaseRequestValue {
    let page: Int
}
