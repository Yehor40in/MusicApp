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
    @IBOutlet private weak var addToPlaylistButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!
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
        addToPlaylistButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
        shuffleButton.layer.cornerRadius = Config.cornerRadiusPlaceholder
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
        player?.backward()
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
        player?.forward()
        delegate?.updateCover(with: player?.nowPlayingItem)
        updateDetails()
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
    }
    @objc func trackAudio() {
        guard songProgress.progress < 1 else {
            player?.forward()
            delegate?.updateCover(with: player?.nowPlayingItem)
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
        guard let data = player?.query.items else { return UITableViewCell() }
        if let cell = nextInQueue.dequeueReusableCell(withIdentifier: "QueueCell") as? QueueCell {
            cell.item = data[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = player?.query.items else { return 0 }
        return data.count
    }
}
