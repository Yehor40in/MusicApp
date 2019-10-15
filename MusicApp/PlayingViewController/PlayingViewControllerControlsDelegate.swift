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
        self.player.skipToPreviousItem()
        self.updateCover()
    }
    
    
    func playPause() {
        //TODO
    }
    
    
    func forward() {
        self.player.skipToNextItem()
        self.updateCover()
    }
}
