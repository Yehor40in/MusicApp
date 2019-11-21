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
    static var favoritesImagePlaceholder: String {
        return "favorites"
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
    static var favoritesFilename: String {
        return "Favorites.plist"
    }
    static var playlistsFilename: String {
        return "Playlists.plist"
    }
    static var unknownPlaceholder: String {
        return NSLocalizedString("Unknown", comment: "Unknown artist")
    }
    static var songLabelPlaceholder: String {
        return NSLocalizedString("Not playing", comment: "No song is playing")
    }
    static var sortMessagePlaceholder: String {
        return NSLocalizedString("Sort by", comment: "Soring actionsheet title")
    }
    static var actionsMessagePlaceholder: String {
        return NSLocalizedString("Options", comment: "Options action sheet title")
    }
    static var deletePlaceholder: String {
        return NSLocalizedString("Delete", comment: "Delete action")
    }
    static var deleteWaring: String {
        return NSLocalizedString("Are you sure you want to delete?", comment: "Delete warning")
    }
    static var approvePlaceholder: String {
        return NSLocalizedString("Yes", comment: "Approve")
    }
    static var sortArtistPlaceholder: String {
        return NSLocalizedString("Artist", comment: "Sort by artist action placeholder")
    }
    static var favoritesName: String {
        return NSLocalizedString("Favorites", comment: "Favorites playlist title")
    }
    static var takePicturePlaceholder: String {
        return NSLocalizedString("Take picture", comment: "Take picture action plceholder")
    }
    static var choosePicturePlaceholder: String {
        return NSLocalizedString("Choose photo", comment: "Choose photo action placeholder")
    }
    static var defaultPlaylistName: String {
        return NSLocalizedString("Unnamed playlist", comment: "Unnamed playlist placeholder")
    }
    static var actionsLikePlaceholder: String {
        return NSLocalizedString("Like", comment: "Add to favotites action placeholder")
    }
    static var actionsUnlikePlaceholder: String {
        return NSLocalizedString("Unlike", comment: "Remove from favorites action placeholder")
    }
    static var sortTitlePlaceholder: String {
        return NSLocalizedString("Title", comment: "Sort by title action placeholder")
    }
    static var recentlyAddedPlaceholder: String {
        return NSLocalizedString("Recently added", comment: "Sort by date action placeholer")
    }
    static var actionsAddToPlaceholder: String {
        return NSLocalizedString("Add to playlist", comment: "Add to playlist action placeholder")
    }
    static var dismissMessage: String {
        return NSLocalizedString("Dismiss", comment: "Dismiss action placeholder")
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
