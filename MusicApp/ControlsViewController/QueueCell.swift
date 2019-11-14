//
//  QueueCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/23/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class QueueCell: CellPrototype {
    var item: MPMediaItem? {
        didSet {
            let img = item?.artwork?.image(at: name.bounds.size)
            cover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            name.text = item?.title
            artist.text = item?.artist ?? Config.unknownPlaceholder
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
