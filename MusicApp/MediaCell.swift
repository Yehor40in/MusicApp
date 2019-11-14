//
//  MediaCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 11/14/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

final class MediaCell: CellPrototype {
    // MARK: - Properties
    var item: MediaItem? {
        didSet {
            cover.image = item?.artwork.getImage()
            name.text = item?.title
            artist.text = item?.artist
        }
    }
}
