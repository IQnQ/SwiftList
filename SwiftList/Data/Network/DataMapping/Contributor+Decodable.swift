//
//  Contributor+Decodable.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

extension ContributorsPage: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.contributors = try container.decode([Contributor].self)
    }
}


extension Contributor: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = ContriId(try container.decode(Int.self, forKey: .id))
        self.login = try container.decode(String.self, forKey: .login)
        self.avatar = try (container.decodeIfPresent(String.self, forKey:.avatar) ?? "")
    }
    
    
}
