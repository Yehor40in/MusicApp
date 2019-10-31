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

final class PlaylistManager {
    static func getFavorites() -> Playlist {
        let path = PlaylistManager.makePath(for: Config.favoritesFilename)
        let decoder = PropertyListDecoder()
        let empty = Playlist(
            image: UIImage(named: Config.favoritesImagePlaceholder),
            name: Config.favoritesName
        )
        guard let data = try? Data(contentsOf: path) else {
            return empty
        }
        do {
            return try decoder.decode(Playlist.self, from: data)
        } catch let error {
            print(error)
        }
        return empty
    }
    static func storeFavorites(item: Playlist) -> Bool {
        let path = PlaylistManager.makePath(for: Config.favoritesFilename)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(item)
            try data.write(to: path)
            return true
        } catch let error {
            print(error)
        }
        return false
    }
    static func isFavorite(item: MPMediaItem) -> Bool {
        let favs = PlaylistManager.getFavorites()
        return favs.items.contains(where: { $0.storeID == item.playbackStoreID })
    }
    static func makePlaylists() -> [Playlist] {
        var playlists: [Playlist] = []
        playlists.append(PlaylistManager.getFavorites())
        guard let list = PlaylistManager.getPlaylists() else { return playlists }
        playlists.append(contentsOf: list)
        return playlists
    }
    static func getPlaylists() -> [Playlist]? {
        let path = PlaylistManager.makePath(for: Config.playlistsFilename)
        let decoder = PropertyListDecoder()
        guard let data = try? Data(contentsOf: path) else { return [] }
        do {
            return try decoder.decode(Array<Playlist>.self, from: data)
        } catch let error {
            print(error)
        }
        return nil
    }
    static func storePlaylists(items: [Playlist]) -> Bool {
        let path = PlaylistManager.makePath(for: Config.playlistsFilename)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(items)
            try data.write(to: path)
            return true
        } catch let error {
            print(error)
        }
        return false
    }
    static func makePath(for resource: String) -> URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(resource)
    }
}
