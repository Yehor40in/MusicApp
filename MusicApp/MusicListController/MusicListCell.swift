//
//  MusicListCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicListCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    // MARK: - Properties
    var item: MPMediaItem? {
        didSet {
            let img = item?.artwork?.image(at: songName.bounds.size)
            self.songCover.image = img ?? UIImage(named: Constants.musicIconPlaceholderName)
            self.songName.text = item?.title
            self.artist.text = item?.artist ?? "Unknown"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        songCover.layer.cornerRadius = Constants.cornerRadiusPlaceholder
    }
}
