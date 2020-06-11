//
//  DefaultRepoRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class DefaultRepoRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultRepoRepository: ReposRepository {
    
    public func reposList(page: Int, completion: @escaping (Result<RepositoriesPage, Error>) -> Void) -> Cancellable? {
        let endpoint = APIEndpoints.repos(page: page)
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)
        return RepositoryTask(networkTask: networkTask)
    }
}
