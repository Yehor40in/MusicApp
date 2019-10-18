//
//  PlayingViewControllerControlsDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/15/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation

extension PlayingViewController: ControlsControllerDelegate {
    // MARK: - ControlsControllerDelegate
    func backward() {
        updateCover(with: self.player?.nowPlayingItem)
        player?.skipToPreviousItem()
        NotificationCenter.default.post(
            name: Constants.trackChangedNotification,
            object: nil,
            userInfo: ["playingItem": (self.player?.nowPlayingItem)!]
        )
    }
    func playPause() {
        switch self.player?.playbackState {
        case .paused:
            player?.play()
            NotificationCenter.default.post(name: Constants.trackResumedNotification, object: nil)
        case .playing:
            player?.pause()
            NotificationCenter.default.post(name: Constants.trackPausedNotification, object: nil)
        default:
            return
        }
    }
    func forward() {
        updateCover(with: self.player?.nowPlayingItem)
        player?.skipToNextItem()
        NotificationCenter.default.post(
            name: Constants.trackChangedNotification,
            object: nil,
            userInfo: ["playingItem": (self.player?.nowPlayingItem)!]
        )
    }
}
