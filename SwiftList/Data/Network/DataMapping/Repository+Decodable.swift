//
//  Repository+Decodable.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

extension RepositoriesPage: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case totalRepos = "total_count"
        case repos = "items"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalRepos = try container.decode(Int.self, forKey: .totalRepos)
        self.repos = try container.decode([Repository].self, forKey: .repos)
    }
}

extension Repository: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case size
        case forks
        case stars = "stargazers_count"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = RepoId(try container.decode(Int.self, forKey: .id))
        self.name = try container.decode(String.self, forKey: .name)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.owner = try container.decode(Owner.self, forKey: .owner)
        self.size = try container.decode(Int.self, forKey: .size)
        self.forks = try container.decode(Int.self, forKey: .forks)
        self.stars = try container.decode(Int.self, forKey: .stars)
    }
}

