//
//  UICollectionViewCell.swift
//  Spotify
//
//  Created by Hussein Kandil on 19/05/2022.
//

import UIKit

final class SpotifyCollectionView: UICollectionView {

    init(frame: CGRect, layout: UICollectionViewFlowLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.cornerRadius = 0
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
