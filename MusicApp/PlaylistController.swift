//
//  PlaylistController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 11/14/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//
import UIKit

final class PlaylistController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var playlistCover: UIImageView!
    @IBOutlet private weak var playlistName: UILabel!
    @IBOutlet private weak var songsAmount: UILabel!
    @IBOutlet private weak var playPlaylistBtn: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    // MARK: - Properties
    var info: Playlist?
    private var player = MusicPlayer.shared
    private var contents: [MediaItem]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        if let temp = info {
            contents = temp.items
            playlistCover.image = temp.artwork.getImage()
            playlistName.text = temp.name
            songsAmount.text = "\(contents?.count ?? 0)"
        }
        navigationItem.largeTitleDisplayMode = .never
    }
    @IBAction func playTapped(_ sender: Any) {
        guard let temp = info else { return }
        player.playPlaylist(temp.getStoreIDs())
    }
}

extension PlaylistController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let temp = contents else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as? MediaCell {
            cell.item = temp[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents?.count ?? 0
    }
}
