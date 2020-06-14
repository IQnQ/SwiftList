//
//  DefaultContriRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class DefaultContriRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultContriRepository: ContriRepository {
    
    public func contriList(query: ContributorsQuery, completion: @escaping (Result<ContributorsPage, Error>) -> Void) -> Cancellable? {
        let endpoint = APIEndpoints.contributors(owner: query.owner, repoName: query.repoName)
        let networkTask = self.dataTransferService.request(with: endpoint, completion: completion)
        return ContributorTask(networkTask: networkTask)
    }
}
