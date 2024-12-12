//
//  UIImageView.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit


//extension UIImageView {
//    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
//        self.image = placeholder
//        guard let urlString = urlString, let url = URL(string: urlString) else { return }
//        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
//            self.image = cachedImage
//            return
//        }
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self,
//                  let data = data,
//                  let image = UIImage(data: data),
//                  error == nil else {
//                return
//            }
//            ImageCache.shared.saveImage(image, forKey: urlString)
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }.resume()
//    }
//}

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






//extension UIImageView {
//    private struct AssociatedKeys {
//        static var dataTask: UInt8 = 0
//    }
//    
//    private var currentDataTask: URLSessionDataTask? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.dataTask) as? URLSessionDataTask
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.dataTask, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    func loadImage(from url: String?, placeholder: UIImage?) {
//        guard let urlString = url, let imageURL = URL(string: urlString) else {
//            self.image = placeholder
//            return
//        }
//        
//        // Показать плейсхолдер
//        self.image = placeholder
//        
//        // Проверка кэша
//        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
//            self.image = cachedImage
//            return
//        }
//        
//        // Отменить текущую задачу загрузки, если она есть
//        currentDataTask?.cancel()
//        
//        // Создание новой задачи
//        let dataTask = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
//            guard let self = self, let data = data, error == nil else {
//                return
//            }
//            
//            if let image = UIImage(data: data) {
//                // Сохранение в кэш
//                ImageCache.shared.saveImage(image, forKey: urlString)
//                
//                // Обновление UI на главном потоке
//                DispatchQueue.main.async {
//                    self.image = image
//                }
//            }
//        }
//        
//        // Сохранение задачи в ассоциированном объекте для возможности отмены
//        currentDataTask = dataTask
//        
//        // Запуск задачи
//        dataTask.resume()
//    }
//}




