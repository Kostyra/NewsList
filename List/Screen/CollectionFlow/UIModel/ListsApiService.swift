//
//  GitsApiService.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation

protocol ListsApiServiceProtocol {
    func getLists(page: Int, pageSize: Int) async throws -> [ListUIModel]
}


final class ListsApiService {
    
    //MARK: - Properties
    
    private let mapper: CoreMapperProtocol
    private let networkManager: CoreNetworkManager
    
    //MARK: - Life cycle
    
    init(mapper: CoreMapperProtocol, networkManager: CoreNetworkManager) {
        self.mapper = mapper
        self.networkManager = networkManager
    }
}

//MARK: - extension GitsApiService

extension ListsApiService: ListsApiServiceProtocol {
    func getLists(page: Int, pageSize: Int ) async throws -> [ListUIModel] {
        let endpoint = EnterPoint.gitsList(page: page, pageSize: pageSize)
        let data = try await networkManager.getRequest(enterPoint: endpoint)
        let newsResponse = try await mapper.map(from: data, jsonType: NewsResponse.self)
        let lists = newsResponse.news
        return lists.map { ListUIModel(list: $0) }
    }
}
