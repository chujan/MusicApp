//
//  AllCategoriesResponse.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 05/10/2022.
//

import Foundation
struct AllCategoriesResponse: Codable {
    let categories: Categories
   
}
struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
