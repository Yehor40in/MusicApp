//
//  QueueCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/23/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class QueueCell: UITableViewCell {
    @IBOutlet private weak var songCover: UIImageView!
    @IBOutlet private weak var songName: UILabel!
    @IBOutlet private weak var artist: UILabel!
    var item: MPMediaItem? {
        didSet {
            let img = item?.artwork?.image(at: songName.bounds.size)
            songCover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            songName.text = item?.title
            artist.text = item?.artist ?? Config.unknownPlaceholder
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        songCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
