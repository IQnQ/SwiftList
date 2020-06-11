//
//  RepoQueriesItemCell.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 11..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

final class RepoQueriesItemCell: UITableViewCell {
    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: RepoQueriesItemCell.self)
    @IBOutlet private var titleLabel: UILabel!
    
    func fill(with suggestion: RepoQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }
}
