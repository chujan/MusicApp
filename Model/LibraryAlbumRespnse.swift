//
//  LibraryAlbumRespnse.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 08/10/2022.
//

import Foundation
struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}

