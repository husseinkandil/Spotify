//
//  NumberFormatter.swift
//  Spotify
//
//  Created by Hussein Kandil on 23/05/2022.
//

import UIKit

class SpotifyNumberFormatter {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = false
        return formatter
    }()

    static func formattedNumberOfFollowers(numberOfFollowers: Int) -> String {
        return formatter.string(from: .init(value: numberOfFollowers))!
    }
}
