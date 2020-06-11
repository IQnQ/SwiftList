//
//  ReposSceneDIContainer.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class ReposSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
        
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var repoQueriesStorage: RepoQueriesStorage = CoreDataStorage(maxStorageLimit: 10)
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchReposUseCase() -> SearchReposUseCase {
        return DefaultSearchReposUseCase(reposRepository: makeRepoRepository(),
                                         repoQueriesRepository: makeRepoQueriesRepository())
    }
    
    func makeFetchContributorsUseCase() -> FetchContributorsUseCase {
        return DefaultContributorsUseCase(contriRepository: makeContriRepository())
    }
    
    // MARK: - Repositories
    func makeRepoRepository() -> ReposRepository {
        return DefaultRepoRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeRepoQueriesRepository() -> RepoQueriesRepository {
        return DefaultRepoQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                            repoQueriesPersistentStorage: repoQueriesStorage)
    }
    
    func makeContriRepository() -> ContriRepository {
        return DefaultContriRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeAvatarImagesRepository() -> AvatarImagesRepository {
        return DefaultAvatarImagesRepository(dataTransferService: dependencies.imageDataTransferService,
                                             imageNotFoundData: UIImage(named: "image_not_found")?.pngData())
    }
    
    // MARK: - Repository List
    func makeRepoListViewController() -> UIViewController {
        return RepoListViewController.create(with: makeRepoListViewModel(), repoListViewControllersFactory: self)
    }
    
    func makeRepoListViewModel() -> RepoListViewModel {
        return DefaultRepoListViewModel(searchReposUseCase: makeSearchReposUseCase())
    }
    
    //MARK: - Repository Details
    func makeRepoDetailsViewController(repo: Repository) -> UIViewController {
        return RepoDetailsViewController.create(with: makeRepoDetailsViewModel(repo: repo))
    }
    
    func makeRepoDetailsViewModel(repo: Repository) -> RepoDetailsViewModel {
        return DefaultRepoDetailsViewModel(repo: repo, fetchContributorsUseCase: makeFetchContributorsUseCase(), avatarImagesRepository: makeAvatarImagesRepository())
    }
    
}

extension ReposSceneDIContainer: RepoListViewControllersFactory {}
