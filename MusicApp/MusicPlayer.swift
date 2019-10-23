//
//  MusicPlayer.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/22/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer

final class MusicPlayer {
    static var shared: MusicPlayer = MusicPlayer()
    // MARK: - Properties
    private var player: MPMusicPlayerController
    var query: MPMediaQuery = MPMediaQuery.songs()
    var isPlaying: Bool = false
    var nowPlayingItem: MPMediaItem? {
        get { return player.nowPlayingItem }
        set(item) { player.nowPlayingItem = item }
    }
    var isPrepared: Bool {
        guard player.isPreparedToPlay else { return false }
        return true
    }
    var playbackDuration: TimeInterval {
        return nowPlayingItem?.playbackDuration ?? 0
    }
    var playbackState: MPMusicPlaybackState {
        return player.playbackState
    }
    var playbackTime: TimeInterval {
        return player.currentPlaybackTime
    }
    // MARK: - Initialization
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player.setQueue(with: query)
        self.player.prepareToPlay()
    }
    // MARK: - Methods
    func play() {
        player.play()
    }
    func pause() {
        player.pause()
    }
    func forward() {
        player.skipToNextItem()
    }
    func backward() {
        player.skipToNextItem()
    }
}
