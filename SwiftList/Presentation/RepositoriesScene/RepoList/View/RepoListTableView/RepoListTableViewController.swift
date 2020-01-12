//
//  RepoListTableViewController.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 10..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoListTableViewController: UITableViewController {
    
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    var viewModel: RepoListViewModel!
    var items: [RepoListItemViewModel]! {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = RepoListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
        bind(to: viewModel)
    }
    
    private func bind(to viewModel:RepoListViewModel) {
           viewModel.loadingType.observe(on: self) { [weak self] in self?.update(isLoadingNextPage: $0 == .nextPage) }
       }
    
    func update(isLoadingNextPage: Bool) {
        if isLoadingNextPage {
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = UIActivityIndicatorView(style: .medium)
            nextPageLoadingSpinner?.startAnimating()
            nextPageLoadingSpinner?.isHidden = false
            nextPageLoadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.frame.width, height: 44)
            tableView.tableFooterView = nextPageLoadingSpinner
        } else {
            tableView.tableFooterView = nil
        }
    }
    
}

extension RepoListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoListItemCell.reuseIdentifier, for: indexPath) as? RepoListItemCell else {
            fatalError("Cannot dequeue reusable cell \(RepoListItemCell.self) with reuseIdentifier: \(RepoListItemCell.reuseIdentifier)")
        }
        
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        cell.accessibilityLabel = String(format: NSLocalizedString("Result row %d", comment: ""), indexPath.row + 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(item: items[indexPath.row])
    }
    
}
