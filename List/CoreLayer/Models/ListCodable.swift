//
//  ListCodable.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation

struct NewsResponse: Codable {
    let news: [ListCodable]
}

struct ListCodable: Codable {
    let title: String
    let id: Int
    let titleImageUrl: String?
}
