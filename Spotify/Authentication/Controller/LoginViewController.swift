//
//  LoginViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 24/04/2022.
//

import UIKit

class LoginViewController: UIViewController {

    private lazy var loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2.0
        view.layer.borderColor = CGColor.init(gray: 0.5, alpha: 1.0)
        view.layer.shadowOffset = CGSize.init(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 2.0
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in"
        label.textColor = .appGrayTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spotifyImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        image.tintColor = .link
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        navigationItem.hidesBackButton = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupViews() {
        defer {
            setupConstraints()
        }
        view.addSubview(loginView)
        loginView.addSubview(loginLabel)
        loginView.addSubview(spotifyImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.heightAnchor.constraint(equalToConstant: 50),
            loginView.widthAnchor.constraint(equalToConstant: 300),

            loginLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: loginView.centerYAnchor),

            spotifyImage.trailingAnchor.constraint(equalTo: loginView.trailingAnchor, constant: -10),
            spotifyImage.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 5),
            spotifyImage.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: -5),
            spotifyImage.heightAnchor.constraint(equalToConstant: 48),
            spotifyImage.widthAnchor.constraint(equalToConstant: 48),

        ])
    }

    @objc
    func didTapView() {
        let vc = AuthenticationViewController()
        vc.completion = { [weak self] success in
            guard let self = self else { return }
            self.handleSignin(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleSignin(success: Bool) {
        guard success else {
            let alert = UIAlertController.init(title: "Error", message: "Error while signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }

        let vc = SearchViewController()
        vc.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.pushViewController(vc, animated: true)
    }
}
