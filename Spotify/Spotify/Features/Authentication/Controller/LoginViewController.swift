//
//  ViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit
import RxSwift
import Firebase

class LoginViewController: UIViewController {
    
    private let disposedBag = DisposeBag()
    
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
    
    let viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        navigationItem.hidesBackButton = true
        activateBindings()
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
    
    private func activateBindings() {
        viewModel
            .signedInUserProfile
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { strongSelf, user in
                guard let user = user else { return }
                strongSelf.signinSucceed(user: user)
            }.disposed(by: disposedBag)
    }
    
    @objc
    func didTapLoginButton() {
        Analytics.logEvent("LoginButton_Tapped", parameters: nil)
        
        let vc = WebViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func signinSucceed(user: SignedinUserProfile) {
        let viewModel = SearchViewModel(user: user)
        let vc = SearchViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.pushViewController(vc, animated: true)
    }
}
