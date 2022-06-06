//
//  ArtistAlbumViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 20/05/2022.
//

import UIKit
import SafariServices
import Kingfisher
import RxSwift
import RxCocoa

class ArtistAlbumViewController: UIViewController {

    private var albumResult = [AlbumResponse]()
    private var id: String?
    private var artistName: String?
    private var numberOfFollowers: Int?
    private var firstImage: UIImage?

    private lazy var collectionView: SpotifyCollectionView = {
        let flowLayout = CollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: view.frame.height / 2 - 120)
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
    
    private let viewModel: AlbumViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(with ViewModel: AlbumViewModelProtocol) {
        self.viewModel = ViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        setupView()
        activateBindings()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        backButtonImageView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        backButtonImageView.isHidden = true
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

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func openSafari(with url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func activateBindings() {
        viewModel
            .isLoading
            .observe(on: MainScheduler.instance)
            .bind { isLoading in
                if isLoading {
                    print("Loading started")
                } else {
                    print("Loading finished")
                }
            }.disposed(by: disposeBag)
        
        viewModel
            .onError
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, error in
                strongSelf.showAlert(with: error)
            }.disposed(by: disposeBag)
        
        viewModel
            .openUrl
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, url in
                strongSelf.openSafari(with: url)
            }.disposed(by: disposeBag)
        
        viewModel
            .reload
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, _ in
                strongSelf.collectionView.reloadData()
            }.disposed(by: disposeBag)
    }
}

//MARK: - CollectionView

extension ArtistAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistAlbumCollectionViewCell.identifier, for: indexPath) as! ArtistAlbumCollectionViewCell

        cell.populate(model: viewModel.album(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectAlbum(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StretchyCollectionHeaderView.identifier,
            for: indexPath) as? StretchyCollectionHeaderView {
            
            viewModel
                .headerModel
                .observe(on: MainScheduler.instance)
                .bind { model in
                    guard let model = model else { return }
                    headerView.populate(model: model)
                }.disposed(by: disposeBag)
            
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView
                        , didEndDisplayingSupplementaryView view: UICollectionReusableView
                        , forElementOfKind elementKind: String
                        , at indexPath: IndexPath) {
        
        navigationController?.navigationBar.isHidden = false
//        backButtonImageView.isHidden = true
        let navigation = navigationController?.navigationBar
        guard let navigation = navigation else { return }
        navigationController?.navigationBar.addSubview(backButtonImageView)
        NSLayoutConstraint.activate([
            backButtonImageView.topAnchor.constraint(equalTo: navigation.topAnchor, constant: -5),
            backButtonImageView.leadingAnchor.constraint(equalTo: navigation.leadingAnchor, constant: 5),
            backButtonImageView.bottomAnchor.constraint(equalTo: navigation.bottomAnchor, constant: -2),
            backButtonImageView.widthAnchor.constraint(equalTo: backButtonImageView.heightAnchor)
        ])
        backButtonImageView.tintColor = .black.withAlphaComponent(0.3)
        title = viewModel.artistName
    }

    func collectionView(_ collectionView: UICollectionView
                        , willDisplaySupplementaryView view: UICollectionReusableView
                        , forElementKind elementKind: String
                        , at indexPath: IndexPath) {
        navigationController?.navigationBar.isHidden = true
        self.view.addSubview(backButtonImageView)
        backButtonImageView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButtonImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButtonImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButtonImageView.widthAnchor.constraint(equalToConstant: 50),
            backButtonImageView.heightAnchor.constraint(equalTo: backButtonImageView.widthAnchor),

            backButton.topAnchor.constraint(equalTo: backButtonImageView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: backButtonImageView.bottomAnchor),
            backButton.leadingAnchor.constraint(equalTo: backButtonImageView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: backButtonImageView.trailingAnchor),
        ])
        backButtonImageView.tintColor = .white.withAlphaComponent(0.1)
    }
}


extension ArtistAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: self.view.frame.height / 3)
    }
}

