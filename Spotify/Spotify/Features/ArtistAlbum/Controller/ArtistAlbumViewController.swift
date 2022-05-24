//
//  ArtistAlbumViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 20/05/2022.
//

import UIKit
import SafariServices
import Kingfisher

class ArtistAlbumViewController: UIViewController {

    private var albumResult = [AlbumResponse]()
    private var id: String?
    private var artistName: String?
    private var numberOfFollowers: Int?
    private var firstImage: UIImage?

    private lazy var collectionView: SpotifyCollectionView = {
        let flowLayout = CollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 320)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)

        let collectionView = SpotifyCollectionView(frame: view.frame, layout: flowLayout)
        collectionView.register(StretchyCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StretchyCollectionHeaderView.identifier)
        
        collectionView.register(ArtistAlbumCollectionViewCell.self, forCellWithReuseIdentifier: ArtistAlbumCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 1.00, green: 0.75, blue: 0.27, alpha: 1.00).cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()

    private let backButtonImageView: UIImageView = {
        @AutoLayout var image = UIImageView()
        image.image = UIImage(systemName: "circle.fill")
        image.tintColor = .white.withAlphaComponent(0.1)
        image.isUserInteractionEnabled = true
        return image
    }()

    private lazy var backButton: UIButton = {
        @AutoLayout var button = UIButton()
        let image = UIImageView()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    required init(id: String, artistName: String, numberOfFollowers: Int?) {
        self.id = id
        self.artistName = artistName
        self.numberOfFollowers = numberOfFollowers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        setupView()
        guard let id = self.id else { return }

        APIClient.shared.getArtistAlbum(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let model):
                self.albumResult = model.items
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func setupView() {
        defer {
            setupConstraints()
        }
        view.addSubview(collectionView)
        view.addSubview(backButtonImageView)
        backButtonImageView.addSubview(backButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            backButtonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButtonImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButtonImageView.widthAnchor.constraint(equalToConstant: 50),
            backButtonImageView.heightAnchor.constraint(equalTo: backButtonImageView.widthAnchor),

            backButton.topAnchor.constraint(equalTo: backButtonImageView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: backButtonImageView.bottomAnchor),
            backButton.leadingAnchor.constraint(equalTo: backButtonImageView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backButtonImageView.trailingAnchor),


            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

//MARK: - CollectionView

extension ArtistAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistAlbumCollectionViewCell.identifier, for: indexPath) as! ArtistAlbumCollectionViewCell

        let album: AlbumResponse
        album = albumResult[indexPath.item]
        cell.populate(model: album)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StretchyCollectionHeaderView.identifier,
            for: indexPath) as? StretchyCollectionHeaderView {
            if albumResult.indices.contains(indexPath.item) {
                let album = albumResult[indexPath.row]
                let numberOfFollowersString: String
                if let numberOfFollowers = numberOfFollowers {
                    let formattedNumber = SpotifyNumberFormatter.formattedNumberOfFollowers(numberOfFollowers: numberOfFollowers)
                    numberOfFollowersString = "\(formattedNumber) followers"
                } else {
                    numberOfFollowersString = "-- followers"
                }

                headerView.populate(model: album, numberOfFollowers: numberOfFollowersString)
            }

            return headerView
    }
        return UICollectionReusableView()
    }
}

extension ArtistAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: self.view.frame.height / 3)
    }
}

