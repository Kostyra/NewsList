//
//  Mapper.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

//import Foundation
//
//protocol CoreMapperProtocol {
//    func map<T: Decodable>(from data: Data, jsonType: T.Type) async throws -> T
//}
//
//final class CoreMapper {
//    private lazy var decoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//        return decoder
//    }()
//}
//
//extension CoreMapper: CoreMapperProtocol {
//    func map<T>(from data: Data, jsonType: T.Type) async throws -> T where T : Decodable {
////        print(String(data: data, encoding: .utf8)!)
//        do {
//            let model = try decoder.decode(jsonType.self, from: data)
//            return model
//
//        } catch let error as DecodingError {
//            switch error {
//            case .typeMismatch(let any, let context):
//                print("typeMismatch: \(any), \(context)")
//            case .valueNotFound(let any, let context):
//                print("valueNotFound: \(any), \(context)")
//            case .keyNotFound(let codingKey, let context):
//                print("keyNotFound: \(codingKey), \(context)")
//            case .dataCorrupted(let context):
//                print("dataCorrupted: \(context)")
//            @unknown default:
//                assertionFailure()
//            }
//            throw error
//        } catch {
//            print("ответ из API: Не удалось спарсить данные")
//            print(error.localizedDescription)
//            throw NetworkError.noData
//        }
//    }
//}

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
