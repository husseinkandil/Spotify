//
//  AuthenticationViewController.swift
//  Spotify
//
//  Created by Hussein Kandil on 24/04/2022.
//

import UIKit
import WebKit

class AuthenticationViewController: UIViewController {

    public var completion: ((Bool) -> Void)?

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
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
extension AuthenticationViewController: WKNavigationDelegate {

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

//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url {
//            if url.host == "www.example.com" {
//                self.navigationController?.popViewController(animated: true)
//                decisionHandler(.cancel)
//                let alert = UIAlertController(title: "Error Signing in", message: "", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(alert, animated: true)
//                return
//            }
//        }
//        decisionHandler(.allow)
//    }

}
