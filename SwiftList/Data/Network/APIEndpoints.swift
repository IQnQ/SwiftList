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
    
    static func contributors(owner: String, repoName: String) -> Endpoint<ContributorsPage> {
        
        return Endpoint(path: "repos/\(owner)/\(repoName)/contributors")
    }
    
    static func contributorAvatar(path: String) -> Endpoint<Data> {
        
        let index = path.lastIndex(of: "/")
        let lastPart: String = .init(path.suffix(from: index!))
        
        return Endpoint(path: "u\(lastPart)", responseDecoder: RawDataResponseDecoder())
    }
}
