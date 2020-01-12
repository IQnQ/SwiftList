//
//  NetworkConfig.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

public protocol NetworkConfig {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfig {
    public let baseURL: URL
    public let headers: [String: String]
    public let parameters: [String: String]
    
    public init(baseURL: URL,
                headers: [String: String] = ["Accept":"application/vnd.github.v3+json"],
                parameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.parameters = parameters
    }
}
