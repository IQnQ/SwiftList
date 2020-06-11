//
//  DefaultAvatarImagesRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class DefaultAvatarImagesRepository {
    
    private let dataTransferService: DataTransferService
    private let imageNotFoundData: Data?
    
    init(dataTransferService: DataTransferService,
         imageNotFoundData: Data?) {
        self.dataTransferService = dataTransferService
        self.imageNotFoundData = imageNotFoundData
    }
}

extension DefaultAvatarImagesRepository: AvatarImagesRepository {
    
    func image(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.contributorAvatar(path: imagePath)
        let networkTask = dataTransferService.request(with: endpoint) { [weak self] (response: Result<Data, Error>) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let data):
                completion(.success(data))
                return
            case .failure(let error):
                if case let DataTransferError.networkFailure(networkError) = error, networkError.isNotFoundError,
                    let imageNotFoundData = strongSelf.imageNotFoundData {
                    completion(.success(imageNotFoundData))
                    return
                }
                completion(.failure(error))
                return
            }
        }
        return RepositoryTask(networkTask: networkTask)
    }
}
