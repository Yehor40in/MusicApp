//
//  PreparedData.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer


struct PreparedData {
    var image: UIImage
    var player: MPMusicPlayerController?
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


enum Constants {
    static var musicIconPlaceholderName: String {
        return "defaultmusicicon"
    }
    
    static var songLabelPlaceholder: String {
        return "Not Playing"
    }
    
    static var cornerRadiusPlaceholder: CGFloat {
        return 8
    }
}
