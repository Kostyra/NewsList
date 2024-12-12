//
//  EnterPoint.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation

enum EnterPoint {
    case gitsList(page: Int, pageSize: Int)
    
    var urlRequest: URLRequest {
        switch self {
        case .gitsList(let page, let pageSize):
            let components = URLComponents(string: "https://webapi.autodoc.ru/api/news/\(page)/\(pageSize)")!
            var urlRequest = URLRequest(url: components.url!)
            urlRequest.httpMethod = "GET"
            return urlRequest
        }
    }
}
