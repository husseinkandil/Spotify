//
//  Test.swift
//  Spotify
//
//  Created by Hussein Kandil on 19/05/2022.
//

import UIKit

class ArtistCollectionViewCell: SpotifyCollectionViewCell {

    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let starOneImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(red: 189 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starTwoImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(red: 189 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starThreeImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(red: 189 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starFourImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(red: 189 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starFiveImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(red: 189 / 255, green: 155 / 255, blue: 22 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let starsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        contentView.addSubview(followersLabel)
        contentView.addSubview(starsView)

        starsView.addSubview(starOneImage)
        starsView.addSubview(starTwoImage)
        starsView.addSubview(starThreeImage)
        starsView.addSubview(starFourImage)
        starsView.addSubview(starFiveImage)
        super.setupView()
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([

            starsView.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 8),
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
        super.setupConstraints()
    }

    func populate(model: ArtistProtocol) {
        self.nameLabel.text = model.name

        if let followersNumber = model.followers {
            if let followers = followersNumber.total {
                self.followersLabel.text = SpotifyNumberFormatter.formattedNumberOfFollowers(numberOfFollowers: followers) + " followers"
            }
        }

        if let url = model.images?.first?.url {
            downloadImage(url: url)
        }

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
}

