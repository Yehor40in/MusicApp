//
//  PlayingViewControllerControlsDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/15/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation


extension PlayingViewController: ControlsControllerDelegate {
    
    //MARK: - ControlsControllerDelegate
    func backward() {
        self.updateCover(with: (self.player?.nowPlayingItem)!)
        self.player?.skipToPreviousItem()
        
        NotificationCenter.default.post(
            name: Notification.Name("trackChanged"),
            object: nil,
            userInfo: ["playingItem" : (self.player?.nowPlayingItem)!]
        )
    }
    
    
    func playPause() {
        
        switch self.player?.playbackState {
        case .paused:
            self.player?.play()
            NotificationCenter.default.post(name: Notification.Name("trackResumed"), object: nil)
        case .playing:
            self.player?.pause()
            NotificationCenter.default.post(name: Notification.Name("trackPaused"), object: nil)
        default:
            return
        }
    }
    
    
    func forward() {
        self.updateCover(with: self.player?.nowPlayingItem)
        self.player?.skipToNextItem()
        
        NotificationCenter.default.post(
            name: Notification.Name("trackChanged"),
            object: nil,
            userInfo: ["playingItem" : (self.player?.nowPlayingItem)!]
        )
    }
}
