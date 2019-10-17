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
        
        self.playingRow = indexPath.row
        
        prepareMusicAndSession(for: playingRow!)
        self.player.play()
        
        updatePlayingView(with: (items?[playingRow!])!)
    }
}
