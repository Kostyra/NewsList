//
//  UIView.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView..., translatesAutoresizingMaskIntoConstraints: Bool = false) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            self.addSubview($0)
        }
    }
}
