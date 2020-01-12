//
//  FetchContributorsUseCase.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol FetchContributorsUseCase {
    func execute(requestValue: FetchContributorsUseCaseRequestValue,
                 completion: @escaping (Result<ContributorsPage, Error>) -> Void) -> Cancellable?
}

final class DefaultContributorsUseCase: FetchContributorsUseCase {
    
    private let contriRepository: ContriRepository
    
    init(contriRepository: ContriRepository) {
        self.contriRepository = contriRepository
    }
    
    func execute(requestValue: FetchContributorsUseCaseRequestValue,
                 completion: @escaping (Result<ContributorsPage, Error>) -> Void) -> Cancellable? {
        return contriRepository.contriList(owner: requestValue.owner, repoName: requestValue.repoName) { result in
            
            switch result {
            case .success:
                completion(result)
            case .failure:
                completion(result)
            }
        }
    }
}

struct FetchContributorsUseCaseRequestValue {
    let owner: String
    let repoName: String
}

