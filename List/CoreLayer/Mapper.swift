//
//  Mapper.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation
import Combine

// MARK: - CoreMapperProtocol
protocol CoreMapperProtocol {
    func map<T: Decodable>(data: Data, jsonType: T.Type) -> AnyPublisher<T, Error>
}

final class CoreMapper {
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
}

extension CoreMapper: CoreMapperProtocol {
    func map<T: Decodable>(data: Data, jsonType: T.Type) -> AnyPublisher<T, Error> {
        Just(data)
            .decode(type: jsonType, decoder: decoder)
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Unknown error: \(error)")
                }
                return NetworkError.noData
            }
            .eraseToAnyPublisher()
    }
}
