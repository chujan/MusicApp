//
//  SearchResult.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 05/10/2022.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
