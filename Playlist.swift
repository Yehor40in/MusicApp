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
    var artwork: URL?
    var name: String
    var items: [MPMediaItem]?
    
    init(imgPath: URL?, name: String) {
        self.artwork = imgPath
        self.name = name
    }
}
