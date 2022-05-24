//
//  ArtistAlbumCollectionViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 20/05/2022.
//

import UIKit

class ArtistAlbumCollectionViewCell: SpotifyCollectionViewCell {

    private let albumName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.textColor = .white
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

    override func setupView() {

        contentView.addSubview(image)
        contentView.addSubview(albumName)
        contentView.addSubview(artistName)
        contentView.addSubview(dateReleased)
        contentView.addSubview(numberOfTracks)
        contentView.addSubview(numberOfArtists)

        super.setupView()
    }

    override func setupConstraints() {
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

            numberOfArtists.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            numberOfArtists.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            numberOfTracks.bottomAnchor.constraint(equalTo: numberOfArtists.topAnchor, constant: -3),
            numberOfTracks.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            dateReleased.leadingAnchor.constraint(equalTo: numberOfTracks.leadingAnchor),
            dateReleased.bottomAnchor.constraint(equalTo: numberOfTracks.topAnchor, constant: -3),
        ])

        super.setupConstraints()
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

}
