//
//  RepoListViewController.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 10..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet weak var repoListContainer: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var suggestionsListContainer: UIView!
    
    private(set) var viewModel: RepoListViewModel!
    
    private var repoQueriesSuggestionsView: UIViewController?
    private var repoListViewControllersFactory: RepoListViewControllersFactory!
    
    private var reposTableViewController: RepoListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)

    
    static func create(with viewModel: RepoListViewModel,
                               repoListViewControllersFactory: RepoListViewControllersFactory) -> RepoListViewController {
           let view = RepoListViewController.instantiateViewController()
           view.viewModel = viewModel
           view.repoListViewControllersFactory = repoListViewControllersFactory
           return view
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyDataLabel.text = NSLocalizedString("Search results", comment: "")
        setupSearchController()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: RepoListViewModel) {
        viewModel.route.observe(on: self) { [weak self] in self?.handle($0) }
        viewModel.items.observe(on: self) { [weak self] in
            self?.reposTableViewController?.items = $0 }
        viewModel.repoCount.observe(on: self){ [weak self] in
            self?.title = NSLocalizedString("Swift repositories: \($0)", comment: "") }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.loadingType.observe(on: self) { [weak self] _ in self?.updateViewsVisibility() }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: RepoListTableViewController.self),
            let destinationVC = segue.destination as? RepoListTableViewController {
            reposTableViewController = destinationVC
            reposTableViewController?.viewModel = viewModel
        }
    }
    
    private func updateViewsVisibility() {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        repoListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        
        switch viewModel.loadingType.value {
        case .none: updateRepoListVisibility()
        case .fullScreen: loadingView.isHidden = false
        if let items = self.reposTableViewController?.items, items.isEmpty {
            emptyDataLabel.text = NSLocalizedString("No results", comment: "")
            }
        case .nextPage: repoListContainer.isHidden = false
        }
        updateQueriesSuggestionsVisibility()
    }
    
    private func updateRepoListVisibility() {
       
        guard !viewModel.isEmpty else {
            emptyDataLabel.isHidden = false
            return
        }
        repoListContainer.isHidden = false
    }
    
    private func updateQueriesSuggestionsVisibility() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }
}

extension RepoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        reposTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension RepoListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
}

// MARK: - Setup Search Controller

extension RepoListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Repositories", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
    }
}

// MARK: - Handle Routing

extension RepoListViewController {
    func handle(_ route: RepoListViewModelRoute) {
        switch route {
        case .initial:break
        case .showRepoDetail(let repo):
            let vc = repoListViewControllersFactory.makeRepoDetailsViewController(repo: repo)
            navigationController?.pushViewController(vc, animated: true)
            
        case .showRepoQueriesSuggestions(let delegate):
            guard let view = view else { return }
            let vc = repoQueriesSuggestionsView ?? repoListViewControllersFactory.makeRepoQueriesSuggestionsListViewController(delegate: delegate)
            add(child: vc, container: suggestionsListContainer)
            vc.view.frame = view.bounds
            repoQueriesSuggestionsView = vc
            suggestionsListContainer.isHidden = false
        case .closeRepoQueriesSuggestions:
            guard let suggestionsListContainer = suggestionsListContainer else { return }
            repoQueriesSuggestionsView?.remove()
            repoQueriesSuggestionsView = nil
            suggestionsListContainer.isHidden = true
        }
    }
}

protocol RepoListViewControllersFactory {
    func makeRepoQueriesSuggestionsListViewController(delegate: RepoQueryListViewModelDelegate) -> UIViewController
    func makeRepoDetailsViewController(repo: Repository) -> UIViewController
}
