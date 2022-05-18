//
//  UIView.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(with error: Error) {
        if let error = error as? APIError {
            switch error {
            case .failedFetchingData:
                showAlert(with: "Failed to fetch data!")

            case .custom(let message):
                showAlert(with: message)
            }
        } else {
            showAlert(with: error.localizedDescription)
        }
    }

    func showAlert(with message: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
