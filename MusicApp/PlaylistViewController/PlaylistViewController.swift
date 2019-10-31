//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class PlaylistViewController: ViewManager {
    // MARK: - Properties
    private var items = PlaylistManager.makePlaylists()
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        playingCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
        playingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDetails(_:))))
        navigationController?.navigationBar.prefersLargeTitles = true
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = PlaylistManager.makePlaylists()
        tableView.reloadData()
        updatePlayingView()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        // Implementation
        //
    }
}

extension PlaylistViewController: UITableViewDataSource {
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
