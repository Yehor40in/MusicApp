//
//  PlistManager.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/28/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

class PlistManager {
    static func getPlist(withName name: String) -> [Playlist]? {
        var favorites: Playlist?
        var playlists: [Playlist] = []
        if let path = Bundle.main.path(forResource: "Favorites", ofType: "plist"),
           let contents = FileManager.default.contents(atPath: path) {
            favorites = try? PropertyListSerialization.propertyList(
                from: contents,
                options: .mutableContainersAndLeaves,
                format: nil
            ) as? Playlist
        }
        if let favs = favorites {
            playlists.insert(favs, at: 0)
        } else {
            playlists.insert(
                Playlist(image: UIImage(named: Config.favoritesImagePlaceholder), name: Config.favoritesName),
                at: 0
            )
        }
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
           let contents = FileManager.default.contents(atPath: path) {
            let list = try? PropertyListSerialization.propertyList(
                from: contents,
                options: .mutableContainersAndLeaves,
                format: nil
            ) as? [Playlist]
            if let list = list {
                playlists.append(contentsOf: list)
            }
        }
        return playlists
    }
    static func storePlist(withName name: String, items: [Playlist]) -> Bool {
        let path = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("Playlists.plist")
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: items, format: .binary, options: .bitWidth)
            try data.write(to: path)
            return true
        } catch let error {
            print(error)
        }
        return false
    }
}
