//
//  Playlist.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

final class Playlist: Codable {
    // MARK: - Properties
    var artwork: Artwork
    var name: String
    var items: [MediaItem] = []
    // MARK: - Initialization
    init(image: UIImage?, name: String) {
        self.artwork = Artwork(with: image)
        self.name = name
    }
    func getStoreIDs() -> [String] {
        return items.map {
            $0.storeID
        }
    }
}
