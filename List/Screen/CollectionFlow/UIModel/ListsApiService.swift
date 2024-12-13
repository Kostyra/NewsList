//
//  ListsApiService.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation
import Combine

// MARK: - ListsApiServiceProtocol
protocol ListsApiServiceProtocol {
    func getLists(page: Int, pageSize: Int) -> AnyPublisher<[ListUIModel], Error>
}

final class ListsApiService {
    private let mapper: CoreMapperProtocol
    private let networkManager: NetworkManagerProtocol

    init(mapper: CoreMapperProtocol, networkManager: NetworkManagerProtocol) {
        self.mapper = mapper
        self.networkManager = networkManager
    }
}

// MARK: - Extension ListsApiService
extension ListsApiService: ListsApiServiceProtocol {
    func getLists(page: Int, pageSize: Int) -> AnyPublisher<[ListUIModel], Error> {
        let endpoint = EnterPoint.numlist(page: page, pageSize: pageSize)
        return networkManager.getRequest(enterPoint: endpoint)
            .flatMap { [weak self] data -> AnyPublisher<NewsResponse, Error> in
                guard let self = self else {
                    return Fail(error: NetworkError.noData).eraseToAnyPublisher()
                }
                return self.mapper.map(data: data, jsonType: NewsResponse.self)
            }
            .map { response in
                response.news.map { ListUIModel(list: $0) }
            }
            .eraseToAnyPublisher()
    }
}
