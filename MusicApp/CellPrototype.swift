//
//  CellPrototype.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 11/14/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class CellPrototype: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet internal weak var cover: UIImageView!
    @IBOutlet internal weak var name: UILabel!
    @IBOutlet internal weak var artist: UILabel!
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        cover.layer.cornerRadius = Config.cornerRadiusPlaceholder
    }
}
