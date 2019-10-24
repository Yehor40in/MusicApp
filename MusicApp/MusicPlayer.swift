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
    var upNext: [MPMediaItem]?
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
        setUpNext()
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
        updateUpNext(forward: false)
    }
    func setUpNext() {
        guard let queue = query.items else { return }
        guard let item = nowPlayingItem else { return }
        if let index = queue.firstIndex(of: item) {
            let slice = queue.suffix(from: index + 1)
            upNext = Array(slice)
        }
    }
    func updateUpNext(forward: Bool) {
        if forward {
            upNext = upNext?.filter { $0 != nowPlayingItem }
        } else {
            guard let temp = nowPlayingItem else { return }
            upNext?.insert(temp, at: 0)
        }
    }
    func goToNextInQueue() {
        if let queue = upNext {
            nowPlayingItem = queue.first
            play()
        }
        updateUpNext(forward: true)
    }
}
