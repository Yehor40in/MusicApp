//
//  PreparedData.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

struct PreparedData {
    var image: UIImage
    var outPosition: Position
}

struct Position {
    var coverOut: CGFloat
    var imageOutBottom: CGFloat
    var imageOutTrailing: CGFloat
}

enum SortOption {
    case artist
    case title
    case date
}

enum Config {
    static var musicIconPlaceholderName: String {
        return "defaultmusicicon"
    }
    static var playlistIconPlaceholder: String {
        return "defaultplaylisticon"
    }
    static var songLabelPlaceholder: String {
        return "Not Playing"
    }
    static var unknownPlaceholder: String {
        return "Unknown"
    }
    static var pauseImagePlaceholder: String {
        return "pause"
    }
    static var playImagePlaceholder: String {
        return "play"
    }
    static var forwardImagePlaceholder: String {
        return "forward"
    }
    static var backwardImagePlaceholder: String {
        return "backward"
    }
    static var sortMessagePlaceholder: String {
        return "Sort by"
    }
    static var actionsMessagePlaceholder: String {
        return "Options"
    }
    static var sortArtistPlaceholder: String {
        return "Artist"
    }
    static var favoritesImagePlaceholder: String {
        return "favorites"
    }
    static var favoritesName: String {
        return "Favorites"
    }
    static var actionsLikePlaceholder: String {
        return "Like ❤️"
    }
    static var sortTitlePlaceholder: String {
        return "Title"
    }
    static var recentlyAddedPlaceholder: String {
        return "Recently added"
    }
    static var actionsAddToPlaceholder: String {
        return "Add to playlist.."
    }
    static var actionsDeletePlaceholder: String {
        return "Delete from library"
    }
    static var dismissMessage: String {
        return "Dismiss"
    }
    static var cornerRadiusPlaceholder: CGFloat {
        return 8
    }
    static var topConstant: CGFloat {
        return 30
    }
    static var sideConstant: CGFloat {
        return 20
    }
    static var sideMultiplier: CGFloat {
        return 0.05
    }
}
