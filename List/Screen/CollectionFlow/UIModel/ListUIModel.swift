//
//  ListUIModel.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit

struct ListUIModel: Hashable {
    var title: String
    var id: Int
    var titleImageUrl: String
    
    init(title: String, titleImageUrl: String, id: Int) {
        self.title = title
        self.id = id
        self.titleImageUrl = titleImageUrl
    }
}

// MARK: - Extension

extension ListUIModel {
    init(list: ListCodable) {
        self.title = list.title
        self.id = list.id
        self.titleImageUrl = list.titleImageUrl ?? ""
    }
}
