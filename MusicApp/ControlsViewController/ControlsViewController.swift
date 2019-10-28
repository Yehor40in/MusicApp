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
        updateDetails()
        repeatButton.layer.backgroundColor = checkRepeating() ?
                                            UIColor.systemGreen.cgColor :
                                            UIColor.lightGray.cgColor
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
        repeatButton.layer.backgroundColor = !repeating ? UIColor.systemGreen.cgColor : UIColor.lightGray.cgColor
    }
    @IBAction func moreTapped(_ sender: Any) {
        let actionSheet = UIAlertController(
            title: nil,
            message: Config.actionsMessagePlaceholder,
            preferredStyle: .actionSheet
        )
        actionSheet.view.tintColor = UIColor.green
        actionSheet.addAction(
            UIAlertAction(title: Config.actionsLikePlaceholder, style: .default, handler: { [weak self] (_) in
            //...
        }))

        actionSheet.addAction(
            UIAlertAction(title: Config.actionsAddToPlaceholder, style: .default, handler: { [weak self] (_) in
            //...
        }))

        actionSheet.addAction(
            UIAlertAction(title: Config.actionsDeletePlaceholder, style: .default, handler: { [weak self] (_) in
            //...
        }))

        actionSheet.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    // MARK: - Utilities
    func checkRepeating() -> Bool {
        guard let repeating = player?.isRepeating else { return false }
        return repeating
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
        guard let progress = player?.playbackTime else { return }
        handleProgress(for: item, value: progress)
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
