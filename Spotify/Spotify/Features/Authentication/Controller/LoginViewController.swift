//
//  ViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit

class LoginViewController: UIViewController {

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.appGrayTextColor, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2.0
        button.layer.borderColor = CGColor.init(gray: 0.5, alpha: 1.0)
        button.layer.shadowOffset = CGSize.init(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 2.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
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
        view.addSubview(loginButton)
        loginButton.addSubview(spotifyImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 300),

            spotifyImage.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -10),
            spotifyImage.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 5),
            spotifyImage.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: -5),
            spotifyImage.widthAnchor.constraint(equalToConstant: 48),

        ])
    }

    @objc
    func didTapLoginButton() {
        let vc = WebViewController()
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
        navigationController?.popViewController(animated: true)
    }
}

class VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
