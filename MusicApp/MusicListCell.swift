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
    //MARK: - Outlets
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    //MARK: - Properties
    var item: MPMediaItem! {
        didSet {
            self.songCover!.image = item!.artwork?.image(at: songName.bounds.size) ?? UIImage(named: "defaultmusicicon")
            self.songName!.text = item!.title!
            self.artist!.text = item!.artist ?? "Unknown"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        songCover.layer.cornerRadius = 8
    }

}
