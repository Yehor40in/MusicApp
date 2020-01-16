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
    var player = MusicPlayer.shared
    private var contents: [MediaItem]?
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        if let temp = info {
            contents = temp.items
            playlistCover.image = temp.artwork.getImage()
            playlistName.text = temp.name
            songsAmount.text = "\(contents?.count ?? 0)"
        }
        tableView.delegate = self
        navigationItem.largeTitleDisplayMode = .never
    }
    // MARK: - Actions
    @IBAction func playTapped(_ sender: Any) {
        guard let temp = info else { return }
        player.setupPlaylist(temp.getStoreIDs())
        player.play()
    }
    @IBAction func moreTapped(_ sender: Any) {
        showAlertController()
    }
    // MARK: - Methods
    // swiftlint:disable line_length identifier_name
    func showAlertController() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.systemPink
        let deleteAction = UIAlertAction(title: Config.deletePlaceholder, style: .destructive, handler: { [weak self] _ in
            let alert = UIAlertController(title: nil, message: Config.deleteWaring, preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemPink
            let confirmDeleteAction = UIAlertAction(title: Config.approvePlaceholder, style: .default, handler: { [weak self] _ in
                guard let id = self?.info?.id else { return }
                PlaylistManager.deletePlaylist(with: id)
                self?.performSegue(withIdentifier: "unwindToPlaylists", sender: self)
            })
            alert.addAction(confirmDeleteAction)
            alert.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel))
            self?.present(alert, animated: true)
        })
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel))
        present(actionSheet, animated: true)
    }
}
// MARK: - TableView DataSource
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        contents?.remove(at: indexPath.row)
        guard
            let identifier = info?.id,
            let temp = contents else { return }
        if PlaylistManager.updatePlaylist(with: identifier, set: temp) {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
// MARK: - TableView Delegate
extension PlaylistController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
