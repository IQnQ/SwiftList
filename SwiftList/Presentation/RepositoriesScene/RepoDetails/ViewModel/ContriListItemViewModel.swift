//
//  ContriListItemViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol ContriListItemViewModelInput {
    func didEndDisplaying()
    func updateAvatarImage(width: Int)
}

protocol ContriListItemViewModelOutput {
    var login: String { get }
    var avatarImage: Observable<Data?> { get }
}

protocol ContriListItemViewModel: ContriListItemViewModelInput, ContriListItemViewModelOutput {}

final class DefaultContriListItemViewModel: ContriListItemViewModel {
    
    private(set) var id: ContriId
    
    private let avatarImagePath: String?
    private let avatarImagesRepository: AvatarImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    
    // MARK: - OUTPUT
    let login: String
    let avatarImage: Observable<Data?> = Observable(nil)


    init(contributor: Contributor, avatarImagesRepository: AvatarImagesRepository) {
        self.id = contributor.id
        self.login = contributor.login
        self.avatarImagePath = contributor.avatar
        self.avatarImagesRepository = avatarImagesRepository
    }
}

extension DefaultContriListItemViewModel {
    
    func didEndDisplaying() {
        avatarImage.value = nil
    }
    
    func updateAvatarImage(width: Int) {
        avatarImage.value = nil
        guard let avatarImagePath = avatarImagePath else { return }
        
        imageLoadTask = avatarImagesRepository.image(with: avatarImagePath, width: width) { [weak self] result in
            guard self?.avatarImagePath == avatarImagePath else { return }
            switch result {
            case .success(let data):
                self?.avatarImage.value = data
            case .failure: break
            }
            self?.imageLoadTask = nil
        }
    }
}

func == (lhs: DefaultContriListItemViewModel, rhs: DefaultContriListItemViewModel) -> Bool {
    return (lhs.id == rhs.id)
}




