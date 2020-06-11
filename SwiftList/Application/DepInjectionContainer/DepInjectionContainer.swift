//
//  DepInjectionContainer.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class DepInjectionIContainer {
    
    lazy var appConfigurations = AppConfig()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!, headers: appConfigurations.apiHeader)

        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.imagesBaseURL)!)
        let imagesDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    // DIContainers of scenes
    func makeReposSceneDIContainer() -> ReposSceneDIContainer {
        let dependencies = ReposSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, imageDataTransferService: imageDataTransferService)
        return ReposSceneDIContainer(dependencies: dependencies)
    }
}
