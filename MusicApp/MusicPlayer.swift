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
    private var player: MPMusicPlayerController?
    private var tempUpNext: [MPMediaItem] = []
    private var currentIndex: Int = 0
    private var items: [MPMediaItem] = []
    var upNext: [MPMediaItem] = []
    var isPlaying: Bool = false
    var nowPlayingItem: MPMediaItem? {
        get { return player?.nowPlayingItem }
        set(item) { player?.nowPlayingItem = item }
    }
    var isPrepared: Bool {
        guard let plr = player else { return false }
        guard plr.isPreparedToPlay else { return false }
        return true
    }
    var isShuffled: Bool {
        switch player?.shuffleMode {
        case .songs:
            return true
        default:
            return false
        }
    }
    var isRepeating: Bool {
        switch player?.repeatMode {
        case .one:
            return true
        default:
            return false
        }
    }
    var getItems: [MPMediaItem] {
        guard let data = MPMediaQuery.songs().items else { return [] }
        return data
    }
    var playbackDuration: TimeInterval {
        return nowPlayingItem?.playbackDuration ?? 0
    }
    var playbackState: MPMusicPlaybackState {
        guard let plr = player else { return .stopped }
        return plr.playbackState
    }
    var playbackTime: TimeInterval {
        guard let plr = player else { return 0 }
        return plr.currentPlaybackTime
    }
    // MARK: - Initialization
    init() {
        guard let temp = MPMediaQuery.songs().items else { return }
        self.items = temp
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player?.setQueue(with: MPMediaQuery.songs())
        self.player?.prepareToPlay()
    }
    // MARK: - Methods
    func play() {
        player?.play()
    }
    func pause() {
        player?.pause()
    }
    func forward() {
        player?.skipToNextItem()
    }
    func backward() {
        player?.skipToNextItem()
    }
    func setUpNext() {
        guard let item = nowPlayingItem else { return }
        guard let index = getItems.firstIndex(of: item) else { return }
        currentIndex = index
        let slice = getItems.suffix(from: currentIndex + 1)
        upNext = [MPMediaItem](slice.map { $0 })
    }
    func updateUpNext(forward: Bool) {
        guard let item = nowPlayingItem else { return }
        if forward {
            upNext = upNext.filter { $0 != item }
        } else {
            guard currentIndex >= 0 && currentIndex < items.count else { return }
            upNext.insert(getItems[currentIndex], at: 0)
        }
    }
    func shuffleQueue(_ flag: Bool) {
        if flag {
            tempUpNext = upNext
            upNext.shuffle()
            player?.shuffleMode = .songs
        } else {
            upNext = tempUpNext
            player?.shuffleMode = .off
        }
    }
    func goToNextInQueue() {
        nowPlayingItem = upNext.first
        updateUpNext(forward: true)
        let length = upNext.count
        guard currentIndex < length - 1 else { return }
        currentIndex += 1
        guard currentIndex < items.count else {
            currentIndex = 0
            return
        }
        play()
    }
    func goToPreviousInQueue() {
        updateUpNext(forward: false)
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        guard currentIndex >= 0 else {
            currentIndex = items.endIndex
            return
        }
        nowPlayingItem = items[currentIndex]
        play()
    }
    func setRepeating(_ flag: Bool) {
        player?.repeatMode = flag ? .one : .none
    }
}
