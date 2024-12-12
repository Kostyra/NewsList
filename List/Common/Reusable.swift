//
//  Reusable.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

extension UICollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}



