//
//  ContributorTask.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct ContributorTask: Cancellable {
    let networkTask: NetworkCancellable?
    func cancel() {
        networkTask?.cancel()
    }
}
