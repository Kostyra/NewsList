//
//  NetworkManager.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

//import Foundation
//
//protocol NetworkManagerProtocol {
//    func getRequest(enterPoint: EnterPoint) async throws -> Data
//}
//
//final class CoreNetworkManager { }
//
//extension CoreNetworkManager: NetworkManagerProtocol {
//    
//    func getRequest(enterPoint: EnterPoint) async throws -> Data {
//        let (data, response) = try await URLSession.shared.data(for: enterPoint.urlRequest)
//        guard let response = response as? HTTPURLResponse else {
//            throw NetworkError.noInternet
//        }
//        print("http status code: \(response.statusCode)")
//        return data
//    }
//}

import Combine
import Foundation

// MARK: - NetworkManagerProtocol
protocol NetworkManagerProtocol {
    func getRequest(enterPoint: EnterPoint) -> AnyPublisher<Data, Error>
}

final class CoreNetworkManager {}

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
