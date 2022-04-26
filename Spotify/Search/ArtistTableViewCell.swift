//
//  ArtistTableViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 25/04/2022.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        defer {
            setupConstraints()
        }
        contentView.addSubview(label)
        contentView.addSubview(image)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func populate(model: Artist) {
        guard let name = model.name else { return }
        self.label.text = name

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
