//
//  PlaylistCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

final class PlaylistCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var playlistCover: UIImageView!
    @IBOutlet private weak var playlistName: UILabel!
    @IBOutlet private weak var trackCount: UILabel!
    var item: Playlist? {
        didSet {
            playlistCover.image = item?.artwork.getImage()
            playlistName.text = item?.name
            trackCount.text = String(describing: item?.items.count ?? 0)
        }
    }
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        playlistCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
    }
}
