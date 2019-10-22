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
    // MARK: - Delegate
    weak var delegate: ControlsControllerDelegate?
    // MARK: - Propertires
    var vps: Float?
    var updater: CADisplayLink?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControlsNotifications()
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
    func setupControlsNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDetails(_:)),
            name: Notification.Name.trackChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlay(_:)),
            name: Notification.Name.trackPaused,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePaused(_:)),
            name: Notification.Name.trackResumed,
            object: nil
        )
    }
    // MARK: - Actions
    @IBAction func backwardTapped(_ sender: Any) {
        delegate?.backward()
    }
    @IBAction func playTapped(_ sender: Any) {
        delegate?.playPause()
    }
    @IBAction func forwardTapped(_ sender: Any) {
        delegate?.forward()
    }
    @objc func handlePaused(_ notification: Notification) {
        playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
        updater?.isPaused = false
    }
    @objc func handlePlay(_ notification: Notification) {
        playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
        updater?.isPaused = true
    }
    @objc func updateDetails(_ notification: Notification) {
        updater?.invalidate()
        if let item = notification.userInfo?[Config.playingItemKey] as? MPMediaItem {
            songName.text = item.title
            artist.text = item.artist
            if let progress = notification.userInfo?[Config.progressKey] as? Double {
                handleProgress(for: item, value: progress)
            }
        } else {
            songName.text = Config.songLabelPlaceholder
            artist.text = Config.songLabelPlaceholder
        }
        if let state = notification.userInfo?[Config.stateKey] as? MPMusicPlaybackState {
            switch state {
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
    }
    @objc func trackAudio() {
        guard songProgress.progress < 1 else {
            delegate?.forward()
            return
        }
        if let value = vps {
            songProgress.progress += value
        }
    }
}
