//
//  ResultCollectionViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 26/04/2022.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let albumName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 2
        return label
    }()

    private let artistName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let dateReleased: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let numberOfTracks: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private let numberOfArtists: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        return label
    }()

    private lazy var preViewOnSpotifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Preview on spotify", for: .normal)
        button.setTitleColor(.appGrayTextColor, for: .normal)
        button.addTarget(self, action: #selector(preViewOnSpotifyButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(white: 226 / 255, alpha: 1.0).cgColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc
    private func preViewOnSpotifyButtonTapped() {
        didTapPreviewButton?()
    }

    var didTapPreviewButton: (() -> Void)?

    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        contentView.addSubview(albumName)
        contentView.addSubview(artistName)
        contentView.addSubview(dateReleased)
        contentView.addSubview(numberOfTracks)
        contentView.addSubview(numberOfArtists)
        contentView.addSubview(preViewOnSpotifyButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            albumName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5),
            albumName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            albumName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            artistName.topAnchor.constraint(greaterThanOrEqualTo: albumName.bottomAnchor, constant: 3),
            artistName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            preViewOnSpotifyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            preViewOnSpotifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            preViewOnSpotifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            preViewOnSpotifyButton.heightAnchor.constraint(equalToConstant: 25),

            numberOfArtists.bottomAnchor.constraint(equalTo: preViewOnSpotifyButton.topAnchor, constant: -5),
            numberOfArtists.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            numberOfTracks.bottomAnchor.constraint(equalTo: numberOfArtists.topAnchor, constant: -3),
            numberOfTracks.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            dateReleased.leadingAnchor.constraint(equalTo: numberOfTracks.leadingAnchor),
            dateReleased.bottomAnchor.constraint(equalTo: numberOfTracks.topAnchor, constant: -3),



        ])
    }

    func populate(model: AlbumResponse) {
        albumName.text = model.name
        artistName.text = model.artists.first?.name
        dateReleased.text = model.release_date
        numberOfArtists.text = "\(String(Int(model.artists.count))) Artists"
        guard let totalTracks = model.total_tracks else { return }
        numberOfTracks.text = String(Int(totalTracks)) + " Tracks"

        guard let url = model.images?.first?.url else { return }
        downloadImage(url: url)
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
