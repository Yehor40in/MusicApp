//
//  PlistManager.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/28/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class PlaylistManager {
    static func getFavorites() -> Playlist {
        var favorites: Playlist?
        //
        // Implementation
        //
        return favorites ?? Playlist(
            image: UIImage(named: Config.favoritesImagePlaceholder),
            name: Config.favoritesName
        )
    }
    static func storeFavorites(item: Playlist) -> Bool {
        //
        // Implementation
        //
        return false
    }
    static func getPlaylists() -> [Playlist]? {
        var playlists: [Playlist] = []
        //
        // Implementation
        //
        playlists.append(PlaylistManager.getFavorites())
        return playlists
    }
    static func storePlaylists(items: [Playlist]) -> Bool {
        //
        // Implementation
        //
        return false
    }
}
