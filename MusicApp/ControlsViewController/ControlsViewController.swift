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
    private var data: [MPMediaItem]?
    private enum Localized {
        static var upNextLabel: String = NSLocalizedString("Next in queue", comment: "Up Next label")
        static var repeatLabel: String = NSLocalizedString("Repeat", comment: "Repeat")
        static var shuffleTitle: String = NSLocalizedString("Shuffle", comment: "Shuffle")
        static var removedPlaceholder: String = NSLocalizedString("Removed from favorites", comment: "Alert message")
        static var addedPlaceholder: String = NSLocalizedString("Added to favorites", comment: "Alert message")
        static var alertTitle: String = NSLocalizedString("Success", comment: "Alert title")
        static var dismissPlaceholder: String = NSLocalizedString("Dismiss", comment: "Dismiss")
    }
    var vps: Float?
    var player: MusicPlayer = MusicPlayer.shared
    var updater: CADisplayLink?
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nextInQueue.dataSource = self
        nextInQueue.delegate = self
        nextInQueue.isEditing = true
        repeatButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
        shuffleButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
        repeatButton.layer.backgroundColor = checkRepeating() ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        shuffleButton.layer.backgroundColor = checkShuffled() ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        upNextLabel.text = Localized.upNextLabel
        repeatButton.setTitle(Localized.repeatLabel, for: .normal)
        shuffleButton.setTitle(Localized.shuffleTitle, for: .normal)
        updateDetails()
        player.setUpNext()
        data = player.upNext.map { $0 }
    }
    // MARK: - Methods
    func handleProgress(for audio: MPMediaItem?, value: Double) {
        songProgress.progress = 0
        if let item = audio {
            songProgress.progress = Float(value / item.playbackDuration)
            vps = Float(1 / item.playbackDuration)
            updater = CADisplayLink(target: self, selector: #selector(trackAudio))
            updater?.preferredFramesPerSecond = 1
            updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            if player.playbackState == .paused { updater?.isPaused = true }
        }
    }
    func actionSheet() -> UIAlertController {
        return UIAlertController(
            title: nil,
            message: Config.actionsMessagePlaceholder,
            preferredStyle: .actionSheet
        )
    }
    func addToPlaylistAction() -> UIAlertAction {
        return UIAlertAction(title: Config.actionsAddToPlaceholder, style: .default, handler: { [weak self] (_) in
            if let selectVC = self?.storyboard?.instantiateViewController(withIdentifier: "SelectPlaylist")
               as? SelectPlaylistController {
                selectVC.modalPresentationStyle = .overCurrentContext
                selectVC.modalTransitionStyle = .coverVertical
                selectVC.toAdd = MediaItem(with: self?.player.nowPlayingItem)
                let presentationController = selectVC.popoverPresentationController
                presentationController?.sourceView = self?.moreButton.imageView
                presentationController?.delegate = self
                self?.present(selectVC, animated: true)
            }
        })
    }
    func addToFavoritesAction() -> UIAlertAction? {
        var message: String
        var title: String
        let favs = PlaylistManager.getFavorites()
        guard let item = player.nowPlayingItem else { return nil }
        if PlaylistManager.isFavorite(item: item) {
            favs.items = favs.items.filter { item.playbackStoreID != $0.storeID }
            message = Localized.removedPlaceholder
            title = Config.actionsUnlikePlaceholder
        } else {
            favs.items.append(MediaItem(with: item))
            message = Localized.addedPlaceholder
            title = Config.actionsLikePlaceholder
        }
        return UIAlertAction(title: title, style: .default, handler: { [weak self] (_) in
            if PlaylistManager.storeFavorites(item: favs) {
                let successAlert = UIAlertController(
                    title: Localized.alertTitle,
                    message: message,
                    preferredStyle: .alert
                )
                successAlert.view.tintColor = UIColor.green
                successAlert.addAction(UIAlertAction(title: Localized.dismissPlaceholder, style: .cancel))
                self?.present(successAlert, animated: true)
            }
        })
    }
    func showActionSheet() {
        let actions = actionSheet()
        actions.view.tintColor = UIColor.systemPink
        actions.addAction(addToFavoritesAction()!)
        actions.addAction(addToPlaylistAction())
        actions.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))
        present(actions, animated: true, completion: nil)
    }
    func checkRepeating() -> Bool {
        return player.isRepeating
    }
    func checkShuffled() -> Bool {
        return player.isShuffled
    }
    func updateDetails() {
        updater?.invalidate()
        guard let item = player.nowPlayingItem else {
            songName.text = Config.songLabelPlaceholder
            artist.text = Config.songLabelPlaceholder
            return
        }
        handleProgress(for: item, value: player.playbackTime)
        songName.text = item.title
        artist.text = item.artist
        switch player.playbackState {
        case .paused:
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            updater?.isPaused = true
        case .playing:
            playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            updater?.isPaused = false
        default:
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
        }
        nextInQueue.reloadData()
    }
    @objc func trackAudio() {
        if songProgress.progress >= 1 {
            if !player.isRepeating {
                player.goToNextInQueue()
                delegate?.updateCover(with: player.nowPlayingItem)
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
    // MARK: - Actions
    @IBAction func backwardTapped(_ sender: Any) {
        player.goToPreviousInQueue()
        data = player.upNext
        delegate?.updateCover(with: player.nowPlayingItem)
        updateDetails()
    }
    @IBAction func playTapped(_ sender: Any) {
        switch player.playbackState {
        case .paused:
            player.play()
            playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            updater?.isPaused = false
        case .playing:
            player.pause()
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            updater?.isPaused = true
        default:
            return
        }
    }
    @IBAction func forwardTapped(_ sender: Any) {
        player.goToNextInQueue()
        data = player.upNext
        delegate?.updateCover(with: player.nowPlayingItem)
        updateDetails()
    }
    @IBAction func repeatTapped(_ sender: Any) {
        let repeating = checkRepeating()
        player.setRepeating(!repeating)
        repeatButton.layer.backgroundColor = !repeating ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
    }
    @IBAction func shuffleTapped(_ sender: Any) {
        let shuffled = checkShuffled()
        player.shuffleQueue(!shuffled)
        data = player.upNext
        shuffleButton.layer.backgroundColor = !shuffled ? UIColor.systemPink.cgColor : UIColor.lightGray.cgColor
        nextInQueue.reloadData()
    }
    @IBAction func moreTapped(_ sender: Any) {
        showActionSheet()
    }
}
// MARK: - QueueList DataSource
extension ControlsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let data = data,
            let cell = nextInQueue.dequeueReusableCell(withIdentifier: "QueueCell") as? QueueCell,
            indexPath.row < data.count && indexPath.row >= 0 else { return UITableViewCell() }
        cell.item = data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
}

extension ControlsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = player.upNext.remove(at: sourceIndexPath.row)
        player.upNext.insert(temp, at: destinationIndexPath.row)
        nextInQueue.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        data = player.upNext.map { $0 }
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ControlsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
