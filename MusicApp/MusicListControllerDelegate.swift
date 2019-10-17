//
//  MusicListControllerDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

extension MusicListController: UITableViewDelegate {
    //MARK: - TableViewDelegate
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.playingKeyIndex = indexPath.section
        self.playingRow = indexPath.row
        
        let key = Character(sectionTitles![playingKeyIndex!])
        let item = items?[key]![playingRow!]
        
        prepareMusic(for: playingRow!, at: key)
        self.player?.play()
        
        updatePlayingView(with: item!)
    }
}
