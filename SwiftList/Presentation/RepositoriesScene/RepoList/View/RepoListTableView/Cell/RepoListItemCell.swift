//
//  RepoListItemCell.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 10..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: RepoListItemCell.self)
    static let height = CGFloat(30)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    private var viewModel:RepoListItemViewModel!
    
    func fill(with viewModel: RepoListItemViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.repo.name
        fullNameLabel.text = viewModel.repo.fullName
    }
    
}
