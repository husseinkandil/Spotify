//
//  ResultViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 26/04/2022.
//

import UIKit
import SafariServices

class ResultViewController: UIViewController {

    private var albumResult = [AlbumResponse]()
    private var id: String?
    private var artistName: String?

    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 300)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.layer.shadowOpacity = 2
        collectionView.layer.shadowColor = .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    required init(id: String, artistName: String) {
        self.id = id
        self.artistName = artistName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        title = self.artistName
        guard let id = self.id else { return }

            APIClient.shared.getArtistAlbum(id: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success(let model):
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.albumResult = model.items
                case.failure(let error):
                    print(error)
                }
        }
    }

    private func setupView() {
        defer {
            setupConstraints()
        }
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

    func openSafari(with data: AlbumResponse) {
        if let urlString = data.external_urls["spotify"],
           let url = URL(string: urlString),
           UIApplication.shared.canOpenURL(url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
}

//MARK: - CollectionView

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell

        let album: AlbumResponse
            album = albumResult[indexPath.item]
            cell.populate(model: album)
            cell.didTapPreviewButton = { [weak self] in
                guard let self = self  else { return }
                self.openSafari(with: album)
        }
        cell.layer.borderColor = UIColor.init(white: 226 / 255, alpha: 1).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 16
        return cell
    }
}
