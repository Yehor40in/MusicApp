//
//  ControlsViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

class ControlsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    // MARK: - Delegate
    weak var delegate: ControlsControllerDelegate?
    // MARK: - Propertires
    var vps: Float?
    var updater: CADisplayLink?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDetails(_:)),
            name: Constants.trackChangedNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlay(_:)),
            name: Constants.trackPausedNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePaused(_:)),
            name: Constants.trackResumedNotification,
            object: nil
        )
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
        delegate?.backward()
    }
    @IBAction func playTapped(_ sender: Any) {
        delegate?.playPause()
    }
    @IBAction func forwardTapped(_ sender: Any) {
        delegate?.forward()
    }
    @objc func handlePaused(_ notification: Notification) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
        updater?.isPaused = false
    }
    @objc func handlePlay(_ notification: Notification) {
        playButton.setImage(UIImage(named: "play"), for: .normal)
        updater?.isPaused = true
    }
    @objc func updateDetails(_ notification: Notification) {
        updater?.invalidate()
        if let item = notification.userInfo?["playingItem"] as? MPMediaItem {
            songName.text = item.title
            artist.text = item.artist
            if let progress = notification.userInfo?["progress"] as? Double {
                handleProgress(for: item, value: progress)
            }
        } else {
            songName.text = Constants.songLabelPlaceholder
            artist.text = Constants.songLabelPlaceholder
        }
        if let state = notification.userInfo?["state"] as? MPMusicPlaybackState {
            switch state {
            case .paused:
                playButton.setImage(UIImage(named: "play"), for: .normal)
                updater?.isPaused = true
            case .playing:
                playButton.setImage(UIImage(named: "pause"), for: .normal)
                updater?.isPaused = false
            default:
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
    @objc func trackAudio() {
        guard songProgress.progress < 1 else {
            delegate?.forward()
            return
        }
        songProgress.progress += vps!
    }
}
