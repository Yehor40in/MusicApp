//
//  PlaylistBasic.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 11/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

class PlaylistControllerBasic: NSObject {
    internal var items: [Playlist] = PlaylistManager.makePlaylists()
}

extension PlaylistControllerBasic: UITableViewDataSource {
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as? PlaylistCell {
            cell.item = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
