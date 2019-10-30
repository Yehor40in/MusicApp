//
//  Playlist.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer

class Playlist {
    // MARK: - Properties
    var artwork: UIImage?
    var name: String
    var items: [MPMediaItem]?
    // MARK: - Initialization
    init(image: UIImage?, name: String) {
        self.artwork = image
        self.name = name
    }
}
