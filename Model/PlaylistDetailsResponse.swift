//
//  PlaylistDetailsResponse.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 04/10/2022.
//

import Foundation
struct PlayListDetailResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
    
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
