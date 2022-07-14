//
//  WebViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit
import WebKit
import RxSwift

class WebViewController: UIViewController {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            prefs.allowsContentJavaScript = true
        }
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
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
        title = "Sign in"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)

        webView.load(URLRequest(url: viewModel.signinUrl))

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

//MARK: - Navigation Delegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }

        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code"})?.value else { return }
        webView.isHidden = true
        print("code :\(code)")
        
        viewModel.code.accept(code)
    }
}
