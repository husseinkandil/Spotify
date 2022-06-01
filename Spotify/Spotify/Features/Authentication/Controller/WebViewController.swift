//
//  WebViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    public var completion: ((Bool) -> Void)?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)

        guard let url = AuthenticationManager.shared.signinURL else { return }

        webView.load(URLRequest(url: url))

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

        AuthenticationManager.shared.generateToken(code: code) { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.completion?(success)
                }
            }
        }
    }
}
