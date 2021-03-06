//
//  RepoDetailsViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

enum ContriListViewModelLoading {
    case none
    case fullScreen
}

protocol RepoDetailsViewModelInput {
    func viewDidLoad()
}

protocol RepoDetailsViewModelOutput {
    var name: Observable<String> { get }
    var fullName: Observable<String> { get }
    var size: Observable<Int> { get }
    var stars: Observable<Int> { get }
    var forks: Observable<Int> { get }
    var items: Observable<[ContriListItemViewModel]> { get }
    var loadingType: Observable<ContriListViewModelLoading> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
}

protocol RepoDetailsViewModel: RepoDetailsViewModelInput, RepoDetailsViewModelOutput { }

final class DefaultRepoDetailsViewModel: RepoDetailsViewModel {
    
    private let fetchContributorsUseCase: FetchContributorsUseCase
    private let avatarImagesRepository: AvatarImagesRepository
    
    private var contriLoadTask: Cancellable? { willSet { contriLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let name: Observable<String> = Observable("")
    let fullName: Observable<String> = Observable("")
    let size: Observable<Int> = Observable(0)
    let stars: Observable<Int> = Observable(0)
    let forks: Observable<Int> = Observable(0)
    let query: Observable<(String, String)> = Observable(("",""))
    let items: Observable<[ContriListItemViewModel]> = Observable([])
    let loadingType: Observable<ContriListViewModelLoading> = Observable(.none)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    
    
    @discardableResult
    init(repo: Repository, fetchContributorsUseCase: FetchContributorsUseCase, avatarImagesRepository: AvatarImagesRepository) {
        self.fetchContributorsUseCase = fetchContributorsUseCase
        self.name.value = repo.name
        self.fullName.value = repo.fullName
        self.size.value = repo.size
        self.stars.value = repo.stars
        self.forks.value = repo.forks
        self.avatarImagesRepository = avatarImagesRepository
        self.query.value = (repo.owner.login, repo.name)
       
    }
    
    private func appendContributors(_ contributorsPage: ContributorsPage) {
        self.items.value = contributorsPage.contributors.map {
            DefaultContriListItemViewModel(contributor: $0, avatarImagesRepository: avatarImagesRepository)
        }
    }
    
    private func load(_ contriQuery: ContributorsQuery, loadingType: ContriListViewModelLoading) {
        self.loadingType.value = loadingType
        
        let contriRequest = FetchContributorsUseCaseRequestValue(query: contriQuery)
        contriLoadTask = fetchContributorsUseCase.execute(requestValue: contriRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let contributorsPage):
                strongSelf.appendContributors(contributorsPage)
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.loadingType.value = .none
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading movies", comment: "")
    }
}

extension DefaultRepoDetailsViewModel {
    func viewDidLoad() {
        loadContributors()
    }
    
    func loadContributors() {
        guard loadingType.value == .none else { return }
        load(ContributorsQuery(owner: query.value.0, repoName: query.value.1), loadingType: .fullScreen)
    }
}


