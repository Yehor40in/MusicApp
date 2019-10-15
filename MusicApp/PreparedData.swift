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
