//
//  StretchyCollectionViewHeader.swift
//  Spotify
//
//  Created by Hussein Kandil on 20/05/2022.
//

import UIKit

class StretchyCollectionHeaderView: UICollectionReusableView {

     var imageView: UIImageView = {
        @AutoLayout var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var labelBackground: UIView = {
        @AutoLayout var view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()

    var label: UILabel = {
        var frame = CGRect(x: 40, y: 40, width: 300, height: 60)
        @AutoLayout var label = UILabel(frame: frame)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        label.layer.shadowColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        label.frame = frame
        return label
    }()

    var followersLabel: UILabel = {
        @AutoLayout var label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    var AlbumLabel: UILabel = {
        @AutoLayout var label = UILabel()
        label.textColor = .white
        label.text = "Albums"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        defer {
            setupConstraints()
        }
        addSubview(imageView)
        addSubview(label)
        addSubview(followersLabel)
        addSubview(AlbumLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            
            label.bottomAnchor.constraint(equalTo: followersLabel.topAnchor, constant: -2),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            followersLabel.leadingAnchor.constraint(equalTo: AlbumLabel.leadingAnchor),
            followersLabel.bottomAnchor.constraint(equalTo: AlbumLabel.topAnchor, constant: -2),
            followersLabel.heightAnchor.constraint(equalToConstant: 20),

            AlbumLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            AlbumLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),


        ])
    }

    func populate(model: AlbumHeaderModel) {
        
        followersLabel.text = model.followersLabelText
        label.text = model.artistName
        if model.artistImageUrl == nil {
            self.imageView.image = UIImage(named: "placeholderImage")
        } else if let url = model.artistImageUrl {
        downloadImage(url: url)
        }
    }

    func downloadImage(url: String) {
        let placeHolderImage = UIImage(named: "placeholderImage")

        ImageDownlaoder.shared.downloadImage(url: url, completionHandler: { image, _ in
            self.imageView.image = image
        }, placeholderImage: placeHolderImage)
    }
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        layoutAttributes?.forEach { attribute in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y

                if contentOffsetY < 0 {
                    let width = collectionView.frame.width
                    let height = attribute.frame.height - contentOffsetY
                    attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                }
            }
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}