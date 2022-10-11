//
//  LibraryToggleView.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 07/10/2022.
//

import Foundation
import UIKit

protocol LibraryToggleViewViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    enum State {
        case playlist
        case albums
    }
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewViewDelegate?
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
        
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
        
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
        
    }()
    override init (frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlaylists() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapPlaylists(self)
        
        
    }
    
    @objc func didTapAlbums() {
        state = .albums
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.libraryToggleViewDidTapAlbums(self)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        layoutIndicator()
        
        
    }
    
    func layoutIndicator() {
        switch state {
        case.playlist:
            indicatorView.frame = CGRect(x: 0 , y: playlistButton.bottom, width: 100, height: 3)
        case.albums:
            indicatorView.frame = CGRect(x: 100 , y: playlistButton.bottom, width: 100, height: 3)
        }
        
    }
    
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}


