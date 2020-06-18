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
    case showRepoDetail(repo: Repository)
    case showRepoQueriesSuggestions(delegate: RepoQueryListViewModelDelegate)
    case closeRepoQueriesSuggestions
}

enum RepoListViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

enum ListingType {
    case normal
    case search
}

protocol RepoListViewModelInput {
    func viewDidLoad()
    func loadFirstPage()
    func didLoadNextPage()
    func didSearch(query: String)
    func didSearchLoadNextPage(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelect(item: RepoListItemViewModel)
}

protocol RepoListViewModelOutput {
    var route: Observable<RepoListViewModelRoute> { get }
    var items: Observable<[RepoListItemViewModel]> { get }
    var loadingType: Observable<RepoListViewModelLoading> { get }
    var listingType: Observable<ListingType> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var repoCount: Observable<Int> { get }
    var isEmpty: Bool { get }
   
}


protocol RepoListViewModel: RepoListViewModelInput, RepoListViewModelOutput {}

final class DefaultRepoListViewModel: RepoListViewModel {
    
    private let searchReposUseCase: SearchReposUseCase
    private let allReposUseCase: AllReposUseCase
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { return currentPage < totalPageCount }
    
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    
    
    private var reposLoadTask: Cancellable? { willSet { reposLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let route: Observable<RepoListViewModelRoute> = Observable(.initial)
    let items: Observable<[RepoListItemViewModel]> = Observable([])
    let loadingType: Observable<RepoListViewModelLoading> = Observable(.none)
    var listingType: Observable<ListingType> = Observable(.normal)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let repoCount: Observable<Int> = Observable(0)
    var isEmpty: Bool { return items.value.isEmpty }
    
    @discardableResult
    init(searchReposUseCase: SearchReposUseCase, allReposUseCase: AllReposUseCase) {
        self.searchReposUseCase = searchReposUseCase
        self.allReposUseCase = allReposUseCase
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
        listingType.value = .normal
        currentPage = 0
        totalPageCount = 1
        items.value.removeAll()
    }
    
    private func load(loadingType: RepoListViewModelLoading) {
        self.loadingType.value = loadingType
        let reposRequest = AllReposUseCaseRequestValue(page: nextPage)
        reposLoadTask = allReposUseCase.execute(requestValue: reposRequest) { [weak self] result in
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
    
    private func loadSearch(repoQuery: RepositoryQuery, loadingType: RepoListViewModelLoading) {
        self.loadingType.value = loadingType
        let reposRequest = SearchReposUseCaseRequestValue(query: repoQuery, page: nextPage)
        reposLoadTask = searchReposUseCase.execute(requestValue: reposRequest) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let reposPage):
                strongSelf.appendPage(reposPage: reposPage)
                strongSelf.listingType.value = .search
            case .failure(let error):
                strongSelf.handle(error: error)
            }
            strongSelf.loadingType.value = .none
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Loading failed", comment: "")
    }
    
    private func update(repositoryQuery: RepositoryQuery) {
        resetPages()
        self.query.value = repositoryQuery.query
        loadSearch(repoQuery: repositoryQuery, loadingType: .fullScreen)
    }
    
}

// MARK: - INPUT. View event methods
extension DefaultRepoListViewModel {

    func viewDidLoad() {
        loadFirstPage()
    }
    
    func loadFirstPage() {
        resetPages()
        guard hasMorePages, loadingType.value == .none else { return }
        load(loadingType: .none)
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loadingType.value == .none else { return }
        load(loadingType: .nextPage)
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(repositoryQuery: RepositoryQuery(query: query))
    }
    
    func didSearchLoadNextPage(query: String) {
        guard hasMorePages, loadingType.value == .none else { return }
        loadSearch(repoQuery: RepositoryQuery(query: query), loadingType: .nextPage)
    }
    
    func didCancelSearch() {
        reposLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        route.value = .showRepoQueriesSuggestions(delegate: self)
    }
    
    func closeQueriesSuggestions() {
        route.value = .closeRepoQueriesSuggestions
    }
    
    func didSelect(item: RepoListItemViewModel) {
        route.value = .showRepoDetail(repo: item.repo)
    }
}

// MARK: - Delegate method from another model views
extension DefaultRepoListViewModel: RepoQueryListViewModelDelegate {
    func repoQueriesListDidSelect(repoQuery: RepositoryQuery) {
        update(repositoryQuery: repoQuery)
    }
}
