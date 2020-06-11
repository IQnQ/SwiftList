//
//  ContriRepository.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

protocol ContriRepository {
    @discardableResult
    func contriList(owner: String, repoName: String, completion: @escaping (Result<ContributorsPage, Error>) -> Void) -> Cancellable?
}
