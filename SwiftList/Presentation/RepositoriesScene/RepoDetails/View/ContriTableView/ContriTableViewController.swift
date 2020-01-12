//
//  ContriTableViewController.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

import UIKit

final class ContriTableViewController: UITableViewController {
    
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    var viewModel: RepoDetailsViewModel!
    var items: [ContriListItemViewModel]! {
        
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: RepoDetailsViewModel) {
        viewModel.loadingType.observe(on: self) { [weak self] in self?.update(isLoadingNextPage: $0 == .nextPage) }
    }
    
    func update(isLoadingNextPage: Bool) {
        if isLoadingNextPage {
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = UIActivityIndicatorView(style: .large)
            nextPageLoadingSpinner?.startAnimating()
            nextPageLoadingSpinner?.isHidden = false
            nextPageLoadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.frame.width, height: 44)
            tableView.tableFooterView = nextPageLoadingSpinner
        } else {
            tableView.tableFooterView = nil
        }
    }
}

extension ContriTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Contributors", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContriListItemCell.reuseIdentifier, for: indexPath) as? ContriListItemCell else {
            fatalError("Cannot dequeue reusable cell \(ContriListItemCell.self) with reuseIdentifier: \(ContriListItemCell.reuseIdentifier)")
        }
        cell.fill(with: viewModel.items.value[indexPath.row])
        
        return cell
    }
    
}
