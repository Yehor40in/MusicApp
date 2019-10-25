//
//  PlaylistCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var playlistCover: UIImageView!
    @IBOutlet private weak var playlistName: UILabel!
    var item: Playlist? {
        didSet {
            playlistCover.image = item?.artwork ?? UIImage(named: Config.playlistIconPlaceholder)
            playlistName.text = item?.name
        }
    }
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        playlistCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
    }
}
