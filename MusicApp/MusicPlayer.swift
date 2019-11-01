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
    private var tempUpNext: [MPMediaItem]?
    private var currentIndex: Int = 0
    var items: [MPMediaItem] = []
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
    var isShuffled: Bool {
        switch player.shuffleMode {
        case .songs:
            return true
        default:
            return false
        }
    }
    var isRepeating: Bool {
        switch player.repeatMode {
        case .one:
            return true
        default:
            return false
        }
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
        let query = MPMediaQuery.songs()
        if let items = query.items {
            self.items = items
        }
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player.setQueue(with: query)
        self.player.prepareToPlay()
        updateUpNext(forward: true)
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
        guard let item = nowPlayingItem else { return }
        if let index = items.firstIndex(of: item) {
            currentIndex = index
            let slice = items.suffix(from: index + 1)
            upNext = Array(slice)
        }
    }
    func updateUpNext(forward: Bool) {
        if forward {
            upNext = upNext?.filter { $0 != nowPlayingItem }
        } else {
            upNext?.insert(items[currentIndex], at: 0)
        }
    }
    func shuffleQueue(_ flag: Bool) {
        if flag {
            tempUpNext = upNext
            upNext?.shuffle()
            player.shuffleMode = .songs
        } else {
            upNext = tempUpNext
            player.shuffleMode = .off
        }
    }
    func goToNextInQueue() {
        guard let queue = upNext else { return }
        nowPlayingItem = queue.first
        if let length = upNext?.count {
            guard currentIndex < length - 1 else { return }
        }
        currentIndex += 1
        updateUpNext(forward: true)
        play()
    }
    func goToPreviousInQueue() {
        guard currentIndex > 0 else { return }
        updateUpNext(forward: false)
        currentIndex -= 1
        nowPlayingItem = items[currentIndex]
        play()
    }
    func setRepeating(_ flag: Bool) {
        player.repeatMode = flag ? .one : .none
    }
}
