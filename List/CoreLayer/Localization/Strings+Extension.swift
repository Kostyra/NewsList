//
//  Strings+Extension.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation

extension String {
    public var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
