//
//  SearchViewcontroller.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit
import Kingfisher
import RxSwift

class SearchViewController: UIViewController {
    
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
//        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
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
        layout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: view.frame.height / 4 + 80)
        
        let collectionView = SpotifyCollectionView(frame: view.frame, layout: layout)
        collectionView.register(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: ArtistCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    let viewModel: SearchViewModelProtocol
    let disposedBag = DisposeBag()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Artists"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.hidesBackButton = true
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        setupView()
        activateBindings()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
        userImage.isAccessibilityElement = true
        
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
    
    private func activateBindings() {
        viewModel
            .isLoading
            .observe(on: MainScheduler.instance)
            .bind { isLoading in
                if isLoading {
                    print("loading started")
                } else {
                    print("loading finished")
                }
            }.disposed(by: disposedBag)
        
        viewModel
            .onError
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, error in
                strongSelf.showAlert(with: error)
            }.disposed(by: disposedBag)
        
        viewModel
            .reload
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { strongSelf, _ in
                strongSelf.collectionView.reloadData()
            }.disposed(by: disposedBag)
        
        viewModel
            .profileImage
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, image in
                let placeHolderImage = UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                
                if let image = image {
                    strongSelf.userImage.image = image
                } else {
                    strongSelf.userImage.image = placeHolderImage
                }
            }.disposed(by: disposedBag)
        
        viewModel
            .isSignedOut
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind {strongSelf, _ in
                strongSelf.signoutAlert()
            }.disposed(by: disposedBag)
    }
    
    @objc
    func showProfile() {
        
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let nsObject = Bundle.main.infoDictionary!["CFBundleVersion"] as? AnyObject else { return }
        
        let alert = UIAlertController(title: "\(viewModel.userName)", message: "v.\(appVersion) (\(nsObject))", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            
            self.viewModel.signout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
    func signoutAlert() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.userImage.isHidden = true
            
            let apiClient = APIClient()
            let viewModel = LoginViewModel(with: apiClient)
            self.navigationController?.pushViewController(LoginViewController(viewModel: viewModel), animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(alert, animated: true)
    }
}

//MARK: - CollectionView

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.identifier, for: indexPath) as! ArtistCollectionViewCell
        
        cell.populate(model: viewModel.artist(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let artistArray = viewModel.artistArray {
            
            let artist = artistArray[indexPath.row]
            let viewModel = AlbumViewModel(artist: artist)
            let vc = ArtistAlbumViewController(with: viewModel)
            navigationController?.pushViewController(vc, animated: true)
            self.userImage.isHidden = true
        }
    }
}

//MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.replacingOccurrences(of: " ", with: "%20")
        
        if searchText.isEmpty {
            self.viewModel
                .searchText
                .accept("")
            collectionView.isHidden = false
            collectionView.backgroundView = noResultLabel
            viewModel.artistArray = []
            collectionView.reloadData()
            
        } else {
            
            self.collectionView.isHidden = false
            self.collectionView.backgroundView = nil
            self.viewModel
                .searchText
                .accept(text)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
