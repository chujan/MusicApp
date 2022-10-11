//
//  Artist.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 01/10/2022.
//

import Foundation
struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
    
}
