//
//  APIEndpoints.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

struct APIEndpoints {
    
    static func repos(query: String, page: Int) -> Endpoint<RepositoriesPage> {
        
        return Endpoint(path: "search/repositories", parameters: ["q":"language:swift", "page": page, "per_page":"25"])
    }
    
    static func cotributors(owner: String, repoName: String) -> Endpoint<ContributorsPage> {
        
        return Endpoint(path: "repos/\(owner)/\(repoName)/contributors")
    }
}
