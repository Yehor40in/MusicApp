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
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setPlayingItem(for: indexPath)
        self.player?.play()
        self.updatePlayingView()
    }
}

extension MusicListController: PlayingViewControllerDelegate {
    // MARK: - PlayingViewControllerDelegate
    func commitChanges() {
        self.updatePlayingView()
    }
}
