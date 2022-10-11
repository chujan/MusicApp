//
//  NewReleaseCollectionViewCell.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 03/10/2022.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifer = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
        
        
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        
        label.numberOfLines = 0
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width-imageSize-10, height: contentView.height-10))
        artistNameLabel.sizeToFit()
        albumNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right+10, y:5, width: albumLabelSize.width , height: albumLabelHeight)
        
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right+10, y: albumNameLabel.bottom, width: contentView.width - albumCoverImageView.right-10, height: 30)
        
      
        
        
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right+10, y: contentView.bottom-44, width: numberOfTracksLabel.width, height: 44)
        
//        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right+10, y: albumCoverImageView.bottom-50, width: numberOfTracksLabel.width, height: 50)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.name
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberofTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
}
