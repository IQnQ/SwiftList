//
//  ContriListItemCell.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class ContriListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ContriListItemCell.self)
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var viewModel:ContriListItemViewModel!
    
    func fill(with viewModel: ContriListItemViewModel) {
        self.viewModel = viewModel
        loginLabel.text = viewModel.login
        avatarImageView.load(url: URL(string: viewModel.avatar)!)
    }
}


