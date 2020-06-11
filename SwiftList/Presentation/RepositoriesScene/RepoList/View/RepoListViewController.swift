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
    
    
    private(set) var viewModel: RepoListViewModel!
    private var repoListViewControllersFactory: RepoListViewControllersFactory!
    
    private var reposTableViewController: RepoListTableViewController?

    
    static func create(with viewModel: RepoListViewModel,
                               repoListViewControllersFactory: RepoListViewControllersFactory) -> RepoListViewController {
           let view = RepoListViewController.instantiateViewController()
           view.viewModel = viewModel
           view.repoListViewControllersFactory = repoListViewControllersFactory
           return view
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyDataLabel.text = NSLocalizedString("Repository search results", comment: "")
        
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
        
        emptyDataLabel.isHidden = true
        repoListContainer.isHidden = true
        switch viewModel.loadingType.value {
        case .none: updateRepoListVisibility()
        case .fullScreen: loadingView.isHidden = false
        case .nextPage: repoListContainer.isHidden = false
        }
    }
    
    private func updateRepoListVisibility() {
       
        guard !viewModel.isEmpty else {
            emptyDataLabel.isHidden = false
            return
        }
        loadingView.isHidden = true
        repoListContainer.isHidden = false
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }
}

extension RepoListViewController {
    func handle(_ route: RepoListViewModelRoute) {
       switch route {
       case .initial: break
       case .showRepoDetail(let repo):
        let vc = repoListViewControllersFactory.makeRepoDetailsViewController(repo: repo)
           navigationController?.pushViewController(vc, animated: true)
        }
    }
}

protocol RepoListViewControllersFactory {
    func makeRepoDetailsViewController(repo: Repository) -> UIViewController
}
