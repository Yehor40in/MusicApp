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
        var key = Character((sectionTitles?[playingKeyIndex!])!)
        
        //if we faced last item in section then jump to the first one on next section
        if playingRow == (items?[key]!.count)! - 1 {
            self.playingKeyIndex? += 1
            self.playingRow? = 0
            key = Character(sectionTitles![playingKeyIndex!])
            
        } else {
            self.playingRow? += 1
        }
        
        //play music and update playing view
        prepareMusic(for: playingRow!, at: key)
        self.player?.play()
        
        updatePlayingView(with: (items?[key]?[playingRow!])!)
    }
    
}
