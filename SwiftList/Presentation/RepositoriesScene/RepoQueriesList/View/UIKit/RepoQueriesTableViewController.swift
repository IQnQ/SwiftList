//
//  RepoQueriesTableViewController.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoQueriesTableViewController: UITableViewController, StoryboardInstantiable {
    
    private var viewModel: RepoQueryListViewModel!
    
    static func create(with viewModel: RepoQueryListViewModel) -> RepoQueriesTableViewController {
        let view = RepoQueriesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = RepoQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: RepoQueryListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RepoQueriesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Suggestions", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoQueriesItemCell.reuseIdentifier, for: indexPath) as? RepoQueriesItemCell else {
            fatalError("Cannot dequeue reusable cell \(RepoQueriesItemCell.self) with reuseIdentifier: \(RepoQueriesItemCell.reuseIdentifier)")
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}
