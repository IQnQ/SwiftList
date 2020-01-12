//
//  RepoListViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

enum RepoListViewModelRoute {
    case initial
    case showRepoDetail(name: String, fullName: String, owner: Owner, size: Int, stars: Int, forks: Int)
}

enum RepoListViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

protocol RepoListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSelect(item: RepoListItemViewModel)
}

protocol RepoListViewModelOutput {
    var route: Observable<RepoListViewModelRoute> { get }
    var items: Observable<[RepoListItemViewModel]> { get }
    var loadingType: Observable<RepoListViewModelLoading> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var repoCount: Observable<Int> { get }
    var isEmpty: Bool { get }
}

protocol RepoListViewModel: RepoListViewModelInput, RepoListViewModelOutput {}

final class DefaultRepoListViewModel: RepoListViewModel {
    
    private(set) var currentPage: Int = 0
    
    var totalPageCount: Int = 1
    
    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
        return currentPage + 1
    }
    
    private let searchReposUseCase: SearchReposUseCase
    
    private var reposLoadTask: Cancellable? { willSet { reposLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let route: Observable<RepoListViewModelRoute> = Observable(.initial)
    let items: Observable<[RepoListItemViewModel]> = Observable([])
    let loadingType: Observable<RepoListViewModelLoading> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let repoCount: Observable<Int> = Observable(0)
    var isEmpty: Bool { return items.value.isEmpty }
    
    @discardableResult
    init(searchReposUseCase: SearchReposUseCase) {
        self.searchReposUseCase = searchReposUseCase
        loadFirstPage()
      
    }
    
    private func appendPage(reposPage: RepositoriesPage) {
        self.currentPage += 1
        self.totalPageCount = reposPage.totalRepos / 25
        self.items.value = items.value + reposPage.repos.map {
            DefaultRepoListItemViewModel(repo: $0)
        }
        self.repoCount.value = reposPage.totalRepos
        
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        items.value.removeAll()
    }
    
    private func load(repositoryQuery: RepositoryQuery, loadingType: RepoListViewModelLoading) {
        self.loadingType.value = loadingType
        self.query.value = repositoryQuery.query
        let reposRequest = SearchReposUseCaseRequestValue(query: repositoryQuery, page: nextPage)
        reposLoadTask = searchReposUseCase.execute(requestValue: reposRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let reposPage):
                strongSelf.appendPage(reposPage: reposPage)
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.loadingType.value = .none
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading the repos", comment: "")
    }
    
    private func update(repositoryQuery: RepositoryQuery) {
        resetPages()
        load(repositoryQuery: repositoryQuery, loadingType: .fullScreen)
    }
    
}

// MARK: - INPUT. View event methods
extension DefaultRepoListViewModel {

    func viewDidLoad() {}
    
    func loadFirstPage() {
        guard hasMorePages, loadingType.value == .none else { return }
        load(repositoryQuery: RepositoryQuery(query: query.value),
        loadingType: .none)
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loadingType.value == .none else { return }
        load(repositoryQuery: RepositoryQuery(query: query.value),
             loadingType: .nextPage)
    }
    
    func didSelect(item: RepoListItemViewModel) {
        route.value = .showRepoDetail(name: item.name,
                                      fullName: item.fullName, owner: item.owner, size: item.size, stars: item.stars, forks: item.forks)
    }
}
