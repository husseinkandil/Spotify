//
//  SearchViewcontroller.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {

    private var username: String?
    private var artistResults = [Artist]()
    private var pendingRequest: DispatchWorkItem?

    private lazy var navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 0.32, green: 0.61, blue: 0.80, alpha: 1.00).cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 0.75]
        return gradient
    }()

    private lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search for an artist..."
        searchBar.barStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 0.73, green: 0.80, blue: 0.78, alpha: 1.00)
        return searchBar
    }()

    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView: SpotifyCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 260)

        let collectionView = SpotifyCollectionView(frame: view.frame, layout: layout)
        collectionView.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: ArtistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Artists"
        navigationItem.hidesBackButton = true
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        setupView()
        fetchData()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
        collectionView.isHidden = false
        collectionView.backgroundView = noResultLabel

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImage.layer.cornerRadius = userImage.bounds.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userImage.isHidden = false
    }

    fileprivate func fetchData() {
        APIClient.shared.getUserProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.username = model.display_name
                self.downloadImage(urlString: model.images.first?.url)
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }

    private func setupView() {
        defer {
            setupConstraints()
        }
        let navigation = self.navigationController?.navigationBar
        guard let navigation = navigation else { return }
        navigation.addSubview(userImage)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        let navigation = self.navigationController?.navigationBar
        guard let navigation = navigation else { return }

        NSLayoutConstraint.activate([

            userImage.topAnchor.constraint(greaterThanOrEqualTo: navigation.topAnchor),
            userImage.trailingAnchor.constraint(greaterThanOrEqualTo: navigation.trailingAnchor, constant: -10),
            userImage.bottomAnchor.constraint(greaterThanOrEqualTo: navigation.bottomAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50),

            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            searchBar.heightAnchor.constraint(equalToConstant: 45),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

    private func downloadImage(urlString: String?) {
        let placeHolderImage = UIImage(systemName: "person.circle")
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.userImage.image = placeHolderImage
            }
            return
        }

        DispatchQueue.main.async {
            self.userImage.kf.setImage(with: url, placeholder: placeHolderImage)
        }
    }



    @objc
    func showProfile() {
        guard let username = username else { return }
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let nsObject = Bundle.main.infoDictionary!["CFBundleVersion"] as? AnyObject else { return }

        let alert = UIAlertController(title: "Profile", message: "", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Username: \(username)", style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: "Version: \(appVersion) (\(nsObject))", style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            self.signout()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        present(alert, animated: true)
    }

    @objc
    func signout() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to logout?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthenticationManager.shared.signout { success in
                if success {
                    DispatchQueue.main.async {
                        self.userImage.isHidden = true
                        self.navigationController?.pushViewController(LoginViewController(), animated: true)
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel))

        present(alert, animated: true)
    }
}

//MARK: - CollectionView

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.identifier, for: indexPath) as! ArtistCollectionViewCell

        let artistData: Artist
        artistData = artistResults[indexPath.item]
        cell.populate(model: artistData)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedArtistId = artistResults[indexPath.item].id,
           let selectedArtistName = artistResults[indexPath.item].name {
            let numberOfFollowers = artistResults[indexPath.item].followers?.total
            let vc = ArtistAlbumViewController(id: selectedArtistId, artistName: selectedArtistName, numberOfFollowers: numberOfFollowers)
            navigationController?.pushViewController(vc, animated: true)
            self.userImage.isHidden = true
        }
    }
}

//MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequest?.cancel()
        let text = searchText.replacingOccurrences(of: " ", with: "%20")

        if searchText.isEmpty {
            collectionView.isHidden = false
            collectionView.backgroundView = noResultLabel
            artistResults = []
            collectionView.reloadData()
        } else {
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }

                self.collectionView.isHidden = false
                self.collectionView.backgroundView = nil
                APIClient.shared.getartistProfile(artist: text) { result in
                    switch result {
                    case.success(let model):
                        guard let new = model.artists?.items else { return }
                        self.artistResults = new
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    case.failure(let error):
                        print(error)
                    }
                }
            }
            self.pendingRequest = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
