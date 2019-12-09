//
//  MusicListCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class MusicListCell: CellPrototype {
    // MARK: - Properties
    var item: MPMediaItem? {
        didSet {
            let img = item?.artwork?.image(at: name.bounds.size)
            cover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            name.text = item?.title
            artist.text = item?.artist ?? Config.unknownPlaceholder
        }
    }
}
