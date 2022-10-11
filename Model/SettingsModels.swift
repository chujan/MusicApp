//
//  SettingsModels.swift
//  MusicApp
//
//  Created by Jennifer Chukwuemeka on 01/10/2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
