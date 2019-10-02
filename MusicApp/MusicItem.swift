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
    var location: URL!
    var dateAdded: Date!
    
    
    init(image: String? = nil, artist: String, name: String) {
        if let temp = image {
            self.image = temp
        }
        
        self.image = image
        self.artist = artist
        self.name = name
        self.dateAdded = Date()
    }
}
