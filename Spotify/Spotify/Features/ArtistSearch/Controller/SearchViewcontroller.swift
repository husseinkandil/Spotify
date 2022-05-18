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

    private lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupView()
        fetchUserData()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImage.layer.cornerRadius = userImage.bounds.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userImage.isHidden = false
    }

    fileprivate func fetchUserData() {
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

