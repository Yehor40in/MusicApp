//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var playingView: UIView!
    @IBOutlet private weak var playingCover: UIImageView!
    @IBOutlet private weak var playingName: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    private var items: [Playlist]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        items = PlaylistManager.getPlaylists()
        playingCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
        playingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDetails(_:))))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlayingView()
    }
    // MARK: - Utilities
    func updatePlayingView() {
        if let object = MusicPlayer.shared.nowPlayingItem {
            let img = object.artwork?.image(at: playingCover.bounds.size)
            playingCover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            playingName.text = object.title
            switch MusicPlayer.shared.playbackState {
            case .paused:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            case .playing:
                playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            default:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            }
            forwardButton.isEnabled = true
        } else {
            playingCover.image = UIImage(named: Config.musicIconPlaceholderName)
            playingName.text = Config.songLabelPlaceholder
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
        }
    }
    @objc func showDetails(_ sender: UITapGestureRecognizer!) {
        if let details = storyboard?.instantiateViewController(withIdentifier: "detailInfo") as? PlayingViewController {
            guard let navHeight = navigationController?.navigationBar.frame.height else { return }
            let pos = Position(
                coverOut: tableView.frame.height + navHeight,
                imageOutBottom: playingCover.frame.height + playingCover.frame.origin.y,
                imageOutTrailing: playingCover.frame.width + playingCover.frame.origin.x
            )
            if let img = self.view.makeScreenshot() {
                details.prepared = PreparedData(image: img, outPosition: pos)
                details.delegate = self
                details.modalPresentationStyle = .fullScreen
                present(details, animated: false)
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        // Implementation
        //
    }
}

extension PlaylistViewController: PlayingViewControllerDelegate {
    // MARK: - PlayingViewController Delegate
    func commitChanges() {
        updatePlayingView()
    }
}

extension PlaylistViewController: UITableViewDataSource {
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = items else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as? PlaylistCell {
            cell.item = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
}
