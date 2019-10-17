//
//  MusicLisControllerAVDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/3/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import AVFoundation
import UIKit

extension MusicListController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        //if we faced last item in section then jump to the first one
        if playingRow == (items?.count)! - 1 {
            playingRow? = 0
        } else {
            playingRow? += 1
        }
        
        //play music and update playing view
        prepareMusicAndSession(for: playingRow!)
        self.player.play()
        
        updatePlayingView(with: (items?[playingRow!])!)
    }
    
}
