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
    
    //MARK: - Utilities
    func preparedItems(from raw: [MPMediaItem], by option: SortOption) -> [MPMediaItem] {
        var prepared: [MPMediaItem]!
        
        self.sectionTitles = [String]()
        
        switch option {
        case .artist:
            prepared = raw.sorted { $0.artist! < $1.artist! }
            _ = prepared.map {
                self.sectionTitles.append(String($0.artist!.first!))
            }
        case .title:
            prepared = raw.sorted { $0.title! < $1.title! }
            _ = prepared.map {
                self.sectionTitles.append(String($0.title!.first!))
            }
        case .date:
            prepared = raw.sorted { $0.dateAdded < $1.dateAdded }
            _ = prepared.map {
                self.sectionTitles.append(String($0.title!.first!))
            }
        }
        return prepared
    }
    
    
    func preparePlayer() {
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player.setQueue(with: self.query)
        self.player.prepareToPlay()
    }
    
    
    func setPlayingItem(for row: Int) {
        self.player.nowPlayingItem = self.items[row]
    }
    
    
    func updatePlayingView() {
        let object = self.player.nowPlayingItem!
        
        self.playingCover.image = object.artwork?.image(at: self.playingCover!.bounds.size) ?? UIImage(named: "defaultmusicicon")
        self.playingName.text = object.title!
        self.playButton.setImage(UIImage(named: "pause"), for: .normal)
        self.forwardButton.isEnabled = true
    }
    
    
    func playRandomSong() {
        var counter = 0
        for _ in self.items {
            counter += 1
        }
        let row = Int.random(in: 0..<counter)
        
        self.setPlayingItem(for: row)
        self.player.play()
        self.updatePlayingView()
    }
}
