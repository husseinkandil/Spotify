//
//  UIColor.swift
//  Spotify
//
//  Created by Hussein Kandil on 26/04/2022.
//

import UIKit

extension UIColor {

    class var appGrayTextColor: UIColor {
        return UIColor { trait -> UIColor in
            if trait.userInterfaceStyle == .dark {
                return UIColor.white.withAlphaComponent(0.5)
            }
            return UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 0.5)
        }
    }
}
