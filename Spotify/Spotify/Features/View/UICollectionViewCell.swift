//
//  UICollectionViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 19/05/2022.
//

import UIKit

class SpotifyCollectionViewCell: UICollectionViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        defer {
            setupConstraints()
        }
        contentView.addSubview(image)
        contentView.addSubview(nameLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func downloadImage(url: String) {
        self.image.image = UIImage(named: "placeholderImage")
        ImageDownlaoder.shared.downloadImage(url: url, completionHandler: { image, success in
            self.image.image = image
        }, placeholderImage: UIImage(named: "placeholderImage"))
    }
}
