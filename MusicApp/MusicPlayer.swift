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
    // MARK: - Getters & Setters
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
    var cIndex: Int {
        get { return currentIndex }
        set(value) { currentIndex = value }
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
        get { return items }
        set(value) { items = value.map { $0 } }
    }
    var rawItems: [MPMediaItem] {
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
        setupItems(by: .title)
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player?.setQueue(with: MPMediaQuery.songs())
        setUpNext()
        self.player?.prepareToPlay()
    }
    // MARK: - Methods
    func stop() {
        player?.stop()
    }
    func play() {
        player?.play()
    }
    func pause() {
        player?.pause()
    }
    func setupPlaylist(ids: [String]) {
        items = items.filter {
            ids.contains($0.playbackStoreID)
        }
    }
    func playPlaylist(_ ids: [String]) {
        stop()
        setupPlaylist(ids: ids)
        setupQueue(with: ids)
        setUpNext()
        play()
    }
    func playRandomSong() {
        currentIndex = Int.random(in: 0..<rawItems.count)
        nowPlayingItem = rawItems[currentIndex]
    }
    private func getRandomSong() -> MPMediaItem {
        let rand = Int.random(in: 0..<rawItems.count)
        return rawItems[rand]
    }
    func setupQueue(with tracks: Any?) {
        if let temp = tracks as? [String] {
            player?.setQueue(with: temp)
        } else if let temp = tracks as? MPMediaQuery {
            player?.setQueue(with: temp)
        }
    }
    func setupItems(by option: SortOption) {
        switch option {
        case .artist:
            items = rawItems.sorted { $0.artist! < $1.artist! }
        case .title:
            items = rawItems.sorted { $0.title! < $1.title! }
        case .date:
            items = rawItems.sorted { $0.dateAdded < $1.dateAdded }
        }
    }
    func setUpNext() {
        guard let item = nowPlayingItem else { return }
        guard let index = items.firstIndex(of: item) else { return }
        currentIndex = index
        let slice = items.suffix(from: currentIndex + 1)
        upNext = [MPMediaItem](slice.map { $0 })
    }
    func updateUpNext(forward: Bool) {
        guard let item = nowPlayingItem else { return }
        if forward {
            upNext = upNext.filter { $0 != item }
        } else {
            guard currentIndex >= 0 && currentIndex < items.count else { return }
            upNext.insert(items[currentIndex], at: 0)
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
        guard currentIndex <= upNext.count - 1 else {
            currentIndex = 0
            nowPlayingItem = items[currentIndex]
            return
        }
        nowPlayingItem = upNext.first
        updateUpNext(forward: true)
        currentIndex += 1
        play()
    }
    func goToPreviousInQueue() {
        updateUpNext(forward: false)
        currentIndex -= 1
        guard currentIndex >= 0 else {
            currentIndex = items.endIndex - 1
            nowPlayingItem = items[currentIndex]
            return
        }
        nowPlayingItem = items[currentIndex]
        play()
    }
    func setRepeating(_ flag: Bool) {
        player?.repeatMode = flag ? .one : .none
    }
    func getRoutePlaylist(for interval: TimeInterval) -> Bool {
        var counter: TimeInterval = 0
        var routePlaylist = [MediaItem]()
        while counter < interval {
            let temp = getRandomSong()
            routePlaylist.append(MediaItem(with: temp))
            counter += temp.playbackDuration
        }
        let artwork = UIImage(named: Config.playlistIconPlaceholder)
        guard var existed = PlaylistManager.getPlaylists() else { return false }
        existed.append(Playlist(image: artwork, name: "Route playlist", media: routePlaylist))
        return PlaylistManager.storePlaylists(items: existed)
    }
}
