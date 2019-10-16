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
    func preparedItems(from raw: [MPMediaItem], by option: SortOption) -> [Character: [MPMediaItem]] {
        var prepared = [Character: [MPMediaItem]]()
        
        self.sectionTitles = [String]()
        
        switch option {
        case .artist:
            let temp = raw.sorted { $0.artist! < $1.artist! }
            _ = temp.map {
                let key = $0.artist!.first!
                
                if prepared[key] == nil {
                    prepared[key] = [MPMediaItem]()
                }
                prepared[key]!.append($0)
                if !sectionTitles.contains(String(key)) {
                    self.sectionTitles.append(String(key))
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
                if !sectionTitles.contains(String(key)) {
                    self.sectionTitles.append(String(key))
                }
            }
        case .date:
            let temp = raw.sorted { $0.dateAdded < $1.dateAdded }
            
            self.sectionTitles.append(String(" "))
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
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player.setQueue(with: self.query)
        self.player.prepareToPlay()
    }
    
    
    func setPlayingItem(for path: IndexPath) {
        let key = Character(sectionTitles[path.section])
        self.player.nowPlayingItem = self.items![key]![path.row]
    }
    
    
    func updatePlayingView() {
        
        if let object = self.player?.nowPlayingItem {
            self.playingCover.image = object.artwork?.image(at: self.playingCover!.bounds.size) ?? UIImage(named: "defaultmusicicon")
            self.playingName.text = object.title!
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            self.forwardButton.isEnabled = true
        }
    }
    
    
    func playRandomSong() {

        let s = Int.random(in: 0..<self.sectionTitles.count)
        let key = sectionTitles[s].first!
        let r = Int.random(in: 0..<self.items![key]!.count)
        
        
        self.setPlayingItem(for: IndexPath(row: r, section: s))
        self.player.play()
        self.updatePlayingView()
    }
    
    
    @objc func showDetails(_ sender: UITapGestureRecognizer!) {
        
        if let details = self.storyboard?.instantiateViewController(withIdentifier: "detailInfo") as? PlayingViewController {
            
            let pos = Position(
                coverOut: self.tableView.frame.height + (self.navigationController?.navigationBar.frame.height)!,
                imageOutBottom: self.playingCover.frame.height + self.playingCover.frame.origin.y,
                imageOutTrailing: self.playingCover.frame.width + self.playingCover.frame.origin.x
            )
            
            details.prepared = PreparedData(image: self.view.makeScreenshot()!, player: self.player, outPosition: pos)
            details.delegate = self
            details.modalPresentationStyle = .fullScreen
            
            present(details, animated: false)
        }
    }
}
