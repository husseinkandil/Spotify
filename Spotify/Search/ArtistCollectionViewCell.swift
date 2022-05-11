//
//  ArtistTableViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 25/04/2022.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starOneImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starTwoImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starThreeImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starFourImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starFiveImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        defer {
            setupConstraints()
        }
        contentView.addSubview(image)
        contentView.addSubview(nameLabel)
        contentView.addSubview(followersLabel)
        contentView.addSubview(starsView)

        starsView.addSubview(starOneImage)
        starsView.addSubview(starTwoImage)
        starsView.addSubview(starThreeImage)
        starsView.addSubview(starFourImage)
        starsView.addSubview(starFiveImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),


            starsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            starsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            followersLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            followersLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            starOneImage.leadingAnchor.constraint(equalTo: starsView.leadingAnchor, constant: 2),
            starTwoImage.leadingAnchor.constraint(equalTo: starOneImage.trailingAnchor, constant: 2),
            starThreeImage.leadingAnchor.constraint(equalTo: starTwoImage.trailingAnchor, constant: 2),
            starFourImage.leadingAnchor.constraint(equalTo: starThreeImage.trailingAnchor, constant: 2),
            starFiveImage.leadingAnchor.constraint(equalTo: starFourImage.trailingAnchor, constant: 2),

            starsView.heightAnchor.constraint(equalToConstant: 25),
            starOneImage.heightAnchor.constraint(equalToConstant: 23),
            starTwoImage.heightAnchor.constraint(equalToConstant: 23),
            starThreeImage.heightAnchor.constraint(equalToConstant: 23),
            starFourImage.heightAnchor.constraint(equalToConstant: 23),
            starFiveImage.heightAnchor.constraint(equalToConstant: 23),
        ])
    }

    func populate(model: Artist) {
        guard let name = model.name else { return }
        self.nameLabel.text = name
        guard let followersNumber = model.followers else { return }
        guard let followers = followersNumber.total else { return }
        self.followersLabel.text = String(Int(followers)) + " followers"

        guard let url = model.images?.first?.url else { return }
        downloadImage(url: url)

        guard let popularity = model.popularity else { return }
        if popularity == 0 {
            starOneImage.image = UIImage(systemName: "star")
            starTwoImage.image = UIImage(systemName: "star")
            starThreeImage.image = UIImage(systemName: "star")
            starFourImage.image = UIImage(systemName: "star")
            starFiveImage.image = UIImage(systemName: "star")
        } else if popularity <= 20 {
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star")
            starThreeImage.image = UIImage(systemName: "star")
            starFourImage.image = UIImage(systemName: "star")
            starFiveImage.image = UIImage(systemName: "star")
        } else if popularity <= 40 {
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star")
            starFourImage.image = UIImage(systemName: "star")
            starFiveImage.image = UIImage(systemName: "star")
        } else if popularity <= 60 {
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
            starFourImage.image = UIImage(systemName: "star")
            starFiveImage.image = UIImage(systemName: "star")
        } else if popularity <= 80 {
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
            starFourImage.image = UIImage(systemName: "star.fill")
            starFiveImage.image = UIImage(systemName: "star")
        } else if popularity > 81 {
            starOneImage.image = UIImage(systemName: "star.fill")
            starTwoImage.image = UIImage(systemName: "star.fill")
            starThreeImage.image = UIImage(systemName: "star.fill")
            starFourImage.image = UIImage(systemName: "star.fill")
            starFiveImage.image = UIImage(systemName: "star.fill")
        }
    }

    private func downloadImage(url: String) {
        let placeHolderImage = UIImage(systemName: "person.circle")

        let urlString = url
        let url = URL(string: urlString)
        DispatchQueue.main.async {
            self.image.kf.setImage(with: url, placeholder: placeHolderImage)
        }
    }
}
