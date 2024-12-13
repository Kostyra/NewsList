//
//  NetworkManager.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Combine
import Foundation

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    func getRequest(enterPoint: EnterPoint) -> AnyPublisher<Data, Error>
}

final class CoreNetworkManager {}

//MARK: - Extension NetworkManagerProtocol

extension CoreNetworkManager: NetworkManagerProtocol {
    func getRequest(enterPoint: EnterPoint) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: enterPoint.urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.noInternet
                }
                print("http status code: \(response.statusCode)")
                return output.data
            }
            .eraseToAnyPublisher()
    }
}
