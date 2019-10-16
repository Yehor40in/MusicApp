//
//  MusicListCell.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class MusicListCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    //MARK: - Properties
    var item: MusicItem! {
        didSet {
            self.songCover.image = UIImage(named: item!.image!)
            self.songName.text = item!.name
            self.artist.text = item!.artist
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        songCover.layer.cornerRadius = 8
    }

}
