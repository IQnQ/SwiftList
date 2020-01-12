//
//  ContriListItemViewModel.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation


protocol ContriListItemViewModel {
    var login: String { get }
    var avatar: String { get }
}

final class DefaultContriListItemViewModel: ContriListItemViewModel {
    
    private(set) var id: ContriId
    
    // MARK: - OUTPUT
    let login: String
    let avatar: String


    init(contributor: Contributor) {
        self.id = contributor.id
        self.login = contributor.login
        self.avatar = contributor.avatar ?? ""
       
    }
}

func == (lhs: DefaultContriListItemViewModel, rhs: DefaultContriListItemViewModel) -> Bool {
    return (lhs.id == rhs.id)
}




