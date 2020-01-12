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

protocol RepoDetailsViewModel{
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

final class DefaultRepoDetailsViewModel: RepoDetailsViewModel {
    
    private let fetchContributorsUseCase: FetchContributorsUseCase
    
    private var contriLoadTask: Cancellable? { willSet { contriLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let name: Observable<String> = Observable("")
    let fullName: Observable<String> = Observable("")
    let size: Observable<Int> = Observable(0)
    let stars: Observable<Int> = Observable(0)
    let forks: Observable<Int> = Observable(0)
    let items: Observable<[ContriListItemViewModel]> = Observable([])
    let loadingType: Observable<ContriListViewModelLoading> = Observable(.none)
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    
    
    @discardableResult
    init(fetchContributorsUseCase: FetchContributorsUseCase, name: String,
         fullName: String, owner: Owner, size: Int, stars: Int, forks: Int) {
        self.fetchContributorsUseCase = fetchContributorsUseCase
        self.name.value = name
        self.fullName.value = fullName
        self.size.value = size
        self.stars.value = stars
        self.forks.value = forks
        load(owner: owner.login, repoName: name, loadingType: .fullScreen)
    }
    
    private func appendContributors(_ contributorsPage: ContributorsPage) {
        self.items.value = contributorsPage.contributors.map {
            DefaultContriListItemViewModel(contributor: $0)
        }
    }
    
    private func load(owner: String, repoName: String, loadingType: ContriListViewModelLoading) {
        self.loadingType.value = loadingType
        
        let contriRequest = FetchContributorsUseCaseRequestValue(owner: owner, repoName: repoName)
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


