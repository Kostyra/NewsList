//
//  CollectionCell.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private lazy var imageCollection: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 16, weight: .regular)
        textLabel.textColor = .white
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 1
        return textLabel
    }()
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        backgroundColor = .systemGray2
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    private func setup() {
        contentView.addSubviews(imageCollection,title, translatesAutoresizingMaskIntoConstraints: false)
        NSLayoutConstraint.activate([
            imageCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            imageCollection.heightAnchor.constraint(equalToConstant: 70),
            imageCollection.widthAnchor.constraint(equalToConstant: 70),
            imageCollection.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: imageCollection.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func configurationCellTable(with list: ListUIModel, isExpanded: Bool, updateTitleOnly: Bool = false) {
        self.title.text = list.title
        self.title.numberOfLines = isExpanded ? 0 : 1
        if !updateTitleOnly {
            self.imageCollection.loadImage(from: list.titleImageUrl, placeholder: UIImage(named: "placeholder"))
        }
    }

    func expandTitle() {
        self.title.numberOfLines = 0
        self.title.lineBreakMode = .byWordWrapping
    }
}
