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
        ])
    }

    func downloadImage(url: String) {
        let placeHolderImage = UIImage(systemName: "person.circle")

        let urlString = url
        let url = URL(string: urlString)
        DispatchQueue.main.async {
            self.image.kf.setImage(with: url, placeholder: placeHolderImage)
        }
    }
}
