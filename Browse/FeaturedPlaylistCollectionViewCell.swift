//
//  FeaturedPlaylistCollectionViewCell.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 03/10/2022.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifer = "FeaturedPlaylistCollectionViewCell"
    
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
        
        
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
       // contentView.backgroundColor = .red
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
       
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height-30, width: contentView.width-6, height: 30)
        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height-60, width: contentView.width-6, height: 30)
        let imageSize = contentView.height-70
        playlistCoverImageView.frame = CGRect(x: (contentView.width-imageSize)/2, y: 3, width: imageSize, height: imageSize)
        
       
       
      
        
        
     }
    override func prepareForReuse() {
        super.prepareForReuse()
       creatorNameLabel .text = nil
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        creatorNameLabel .text = viewModel.name
        playlistNameLabel.text = viewModel.createName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        
        
    }
    
}

    

