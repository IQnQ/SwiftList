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
    
    private var viewModel:ContriListItemViewModel! { didSet { unbind(from: oldValue) } }
    
    func fill(with viewModel: ContriListItemViewModel) {
        self.viewModel = viewModel
        loginLabel.text = viewModel.login
        viewModel.updateAvatarImage(width: Int(avatarImageView.frame.size.width * UIScreen.main.scale))
        
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: ContriListItemViewModel) {
        viewModel.avatarImage.observe(on: self) { [weak self] in self?.avatarImageView.image = $0.flatMap { UIImage(data: $0) } }
    }
    
    private func unbind(from item: ContriListItemViewModel?) {
        item?.avatarImage.remove(observer: self)
    }
}


