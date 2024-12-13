//
//  UIImageView.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String?, placeholder: UIImage?) {
        guard let urlString = url, let imageURL = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        self.image = placeholder
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            self.image = cachedImage
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } catch {
                print("Ошибка загрузки изображения: \(error)")
            }
        }
    }
}





