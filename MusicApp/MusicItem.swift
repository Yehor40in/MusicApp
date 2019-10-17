//
//  MusicItem.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation


class MusicItem {
    
    //MARK: - Properties
    var image: String?
    var artist: String
    var name: String
    var location: URL
    var dateAdded: Date
    
    
    init(image: String? = nil, artist: String, name: String, path: URL) {
        self.image = image ?? "defaultmusicicon"
        self.artist = artist
        self.name = name
        self.location = path
        self.dateAdded = Date()
    }
}
