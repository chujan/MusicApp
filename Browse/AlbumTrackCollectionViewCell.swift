//
//  AlbumTrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 04/10/2022.
//

import Foundation
import UIKit
class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifer = "AlbumTrackCollectionViewCell"
    
   
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
       backgroundColor = .secondarySystemBackground
     
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
       
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width-15, height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-15, height: contentView.height/2)
       
       
      
        
        
     }
    override func prepareForReuse() {
        super.prepareForReuse()
       artistNameLabel .text = nil
        trackNameLabel.text = nil
       
    }
    
    func configure(with viewModel:AlbumCollectionCellViewModel) {
        artistNameLabel .text = viewModel.name
        trackNameLabel.text = viewModel.artistName
       
        
        
    }
    
}

    


    


