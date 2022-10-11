//
//  SearchResultResponse.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 05/10/2022.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistssResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
    
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
    
}

struct SearchPlaylistssResponse: Codable {
    let items: [Playlist]
    
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
    
}

