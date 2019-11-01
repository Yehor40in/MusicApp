//
//  ControlsViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class ControlsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var songProgress: UIProgressView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var songName: UILabel!
    @IBOutlet private weak var artist: UILabel!
    @IBOutlet private weak var nextInQueue: UITableView!
    @IBOutlet private weak var repeatButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var upNextLabel: UILabel!
    // MARK: - Delegate
    weak var delegate: ControlsControllerDelegate?
    // MARK: - Propertires
    var vps: Float?
    var player: MusicPlayer? = MusicPlayer.shared
    var updater: CADisplayLink?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nextInQueue.dataSource = self
        nextInQueue.delegate = self
        nextInQueue.isEditing = true
        repeatButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
        shuffleButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
        repeatButton.layer.backgroundColor = checkRepeating() ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        shuffleButton.layer.backgroundColor = checkShuffled() ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        upNextLabel.text = NSLocalizedString("Next in queue", comment: "Up Next label")
        repeatButton.setTitle(NSLocalizedString("Repeat", comment: "Repeat"), for: .normal)
        shuffleButton.setTitle(NSLocalizedString("Shuffle", comment: "Shuffle"), for: .normal)
        updateDetails()
    }
    func handleProgress(for audio: MPMediaItem?, value: Double) {
        if let item = audio {
            songProgress.progress = Float(value / item.playbackDuration)
            vps = Float(1 / item.playbackDuration)
            updater = CADisplayLink(target: self, selector: #selector(trackAudio))
            updater?.preferredFramesPerSecond = 1
            updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }
    // MARK: - Actions
    @IBAction func backwardTapped(_ sender: Any) {
        player?.goToPreviousInQueue()
        delegate?.updateCover(with: player?.nowPlayingItem)
        updateDetails()
    }
    @IBAction func playTapped(_ sender: Any) {
        switch player?.playbackState {
        case .paused:
            player?.play()
            playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            updater?.isPaused = false
        case .playing:
            player?.pause()
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            updater?.isPaused = true
        default:
            return
        }
    }
    @IBAction func forwardTapped(_ sender: Any) {
        player?.goToNextInQueue()
        delegate?.updateCover(with: player?.nowPlayingItem)
        updateDetails()
    }
    @IBAction func repeatTapped(_ sender: Any) {
        let repeating = checkRepeating()
        player?.setRepeating(!repeating)
        repeatButton.layer.backgroundColor = !repeating ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
    }
    @IBAction func shuffleTapped(_ sender: Any) {
        let shuffled = checkShuffled()
        player?.shuffleQueue(!shuffled)
        shuffleButton.layer.backgroundColor = !shuffled ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        nextInQueue.reloadData()
    }
    @IBAction func moreTapped(_ sender: Any) {
        let actionSheet = UIAlertController(
            title: nil,
            message: Config.actionsMessagePlaceholder,
            preferredStyle: .actionSheet
        )
        var message: String
        var title: String
        let favs = PlaylistManager.getFavorites()
        guard let item = MusicPlayer.shared.nowPlayingItem else { return }
        if PlaylistManager.isFavorite(item: item) {
            favs.items = favs.items.filter { item.playbackStoreID != $0.storeID }
            message = "Removed from favorites"
            title = Config.actionsUnlikePlaceholder
        } else {
            favs.items.append(MediaItem(with: item))
            message = "Added to favorites"
            title = Config.actionsLikePlaceholder
        }
        actionSheet.view.tintColor = UIColor.systemPink
        actionSheet.addAction(
            UIAlertAction(title: title, style: .default, handler: { [weak self] (_) in
                if PlaylistManager.storeFavorites(item: favs) {
                    let successAlert = UIAlertController(
                        title: "Success",
                        message: message,
                        preferredStyle: .alert
                    )
                    successAlert.view.tintColor = UIColor.green
                    successAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(successAlert, animated: true)
                } else {
                    let failAlert = UIAlertController(
                        title: "Fail",
                        message: "Failed to add to favorites",
                        preferredStyle: .alert
                    )
                    failAlert.view.tintColor = UIColor.systemPink
                    failAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self?.present(failAlert, animated: true)
                }
        }))
        actionSheet.addAction(
            UIAlertAction(title: Config.actionsAddToPlaceholder, style: .default, handler: { [weak self] (_) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectVC = segue.destination as? SelectPlaylistController {
            selectVC.toAdd = MediaItem(with: player?.nowPlayingItem)
        }
    }
    // MARK: - Utilities
    func checkRepeating() -> Bool {
        guard let repeating = player?.isRepeating else { return false }
        return repeating
    }
    func checkShuffled() -> Bool {
        guard let shuffled = player?.isShuffled else { return false }
        return shuffled
    }
    func updateDetails() {
        updater?.invalidate()
        guard let item = player?.nowPlayingItem else {
            songName.text = Config.songLabelPlaceholder
            artist.text = Config.songLabelPlaceholder
            return
        }
        songName.text = item.title
        artist.text = item.artist
        switch player?.playbackState {
        case .paused:
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            updater?.isPaused = true
        case .playing:
            playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            updater?.isPaused = false
        default:
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
        }
        guard let progress = player?.playbackTime else { return }
        handleProgress(for: item, value: progress)
        nextInQueue.reloadData()
    }
    func setPlayingItem(_ item: MPMediaItem) {
        player?.updateUpNext(forward: true)
        player?.nowPlayingItem = item
        updateDetails()
        delegate?.updateCover(with: item)
    }
    @objc func trackAudio() {
        guard songProgress.progress < 1 else {
            guard let repeating = player?.isRepeating else { return }
            if !repeating {
                player?.updateUpNext(forward: true)
                player?.goToNextInQueue()
                delegate?.updateCover(with: player?.nowPlayingItem)
                updateDetails()
            } else {
                songProgress.progress = 0
            }
            return
        }
        if let value = vps {
            songProgress.progress += value
        }
    }
}

extension ControlsViewController: UITableViewDataSource {
    // MARK: - QueueList DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = player?.upNext {
            if let cell = nextInQueue.dequeueReusableCell(withIdentifier: "QueueCell") as? QueueCell {
                guard indexPath.row < data.count else { return UITableViewCell() }
                cell.item = data[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = player?.upNext else { return 0 }
        return data.count
    }
}

extension ControlsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = player?.upNext else { return }
        setPlayingItem(items[indexPath.row])
    }
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if var queue = player?.upNext {
            let temp = queue.remove(at: sourceIndexPath.row)
            queue.insert(temp, at: destinationIndexPath.row)
            player?.upNext = queue
        }
        nextInQueue.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
