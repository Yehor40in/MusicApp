//
//  PlaylistTableViewConroller.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 11/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import Foundation

final class SelectPlaylistController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    private var playlists: [Playlist] = PlaylistManager.makePlaylists()
    var toAdd: MediaItem?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectPlaylistController: UITableViewDataSource {
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as? PlaylistCell {
            cell.item = playlists[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
}

extension SelectPlaylistController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newItem = toAdd else { return }
        if indexPath.row == 0 {
            let favs = PlaylistManager.getFavorites()
            favs.items.append(newItem)
            if PlaylistManager.storeFavorites(item: favs) { dismiss(animated: true, completion: nil) }
        } else {
            if let list = PlaylistManager.getPlaylists() {
                list[indexPath.row - 1].items.append(newItem)
                if PlaylistManager.storePlaylists(items: list) { dismiss(animated: true, completion: nil) }
            }
        }
    }
}
