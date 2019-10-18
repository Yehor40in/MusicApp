//
//  MusicListControllerUtilities.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/4/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import AVFoundation
import MediaPlayer
import UIKit

extension MusicListController {
    // MARK: - Utilities
    func preparedItems(from raw: [MPMediaItem], by option: SortOption) -> [Character: [MPMediaItem]] {
        var prepared = [Character: [MPMediaItem]]()
        sectionTitles = [String]()
        switch option {
        case .artist:
            let temp = raw.sorted { $0.artist! < $1.artist! }
            _ = temp.map {
                let key = $0.artist!.first!
                if prepared[key] == nil {
                    prepared[key] = [MPMediaItem]()
                }
                prepared[key]!.append($0)
                if !sectionTitles!.contains(String(key)) {
                    sectionTitles!.append(String(key))
                }
            }
        case .title:
            let temp = raw.sorted { $0.title! < $1.title! }
            _ = temp.map {
                let key = $0.title!.first!
                if prepared[key] == nil {
                    prepared[key] = [MPMediaItem]()
                }
                prepared[key]!.append($0)
                if !sectionTitles!.contains(String(key)) {
                    sectionTitles!.append(String(key))
                }
            }
        case .date:
            let temp = raw.sorted { $0.dateAdded < $1.dateAdded }
            sectionTitles!.append(String(" "))
            _ = temp.map {
                if prepared[" "] == nil {
                    prepared[" "] = [MPMediaItem]()
                }
                prepared[" "]!.append($0)
            }
        }
        return prepared
    }
    func preparePlayer() {
        player = MPMusicPlayerController.systemMusicPlayer
        player?.setQueue(with: self.query!)
        player?.prepareToPlay()
    }
    func setPlayingItem(for path: IndexPath) {
        let key = Character(sectionTitles![path.section])
        player?.nowPlayingItem = self.items?[key]?[path.row]
    }
    func updatePlayingView() {
        if let object = self.player?.nowPlayingItem {
            let img = object.artwork?.image(at: self.playingCover!.bounds.size)
            playingCover.image = img ?? UIImage(named: Constants.musicIconPlaceholderName)
            playingName.text = object.title!
            switch self.player?.playbackState {
            case .paused:
                playButton.setImage(UIImage(named: "play"), for: .normal)
            case .playing:
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            default:
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
            self.forwardButton.isEnabled = true
        }
    }
    func playRandomSong() {

        let sec = Int.random(in: 0..<self.sectionTitles!.count)
        let key = sectionTitles![sec].first!
        let row = Int.random(in: 0..<self.items![key]!.count)
        setPlayingItem(for: IndexPath(row: row, section: sec))
        player?.play()
        updatePlayingView()
    }
    @objc func showDetails(_ sender: UITapGestureRecognizer!) {
        if let details = storyboard?.instantiateViewController(withIdentifier: "detailInfo") as? PlayingViewController {
            let pos = Position(
                coverOut: tableView.frame.height + (navigationController?.navigationBar.frame.height)!,
                imageOutBottom: playingCover.frame.height + playingCover.frame.origin.y,
                imageOutTrailing: playingCover.frame.width + playingCover.frame.origin.x
            )
            details.prepared = PreparedData(image: self.view.makeScreenshot()!, player: player, outPosition: pos)
            details.delegate = self
            details.modalPresentationStyle = .fullScreen
            present(details, animated: false)
        }
    }
}
