//
//  MovieQueryEntity+Mappings.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation
import CoreData

extension RepositoryQueryEntity {
    convenience init(repositoryQuery: RepositoryQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = repositoryQuery.query
        createdAt = Date()
    }
}

extension RepositoryQuery {
    init(repositoryQueryEntity: RepositoryQueryEntity) {
        query = repositoryQueryEntity.query ?? ""
    }
}
