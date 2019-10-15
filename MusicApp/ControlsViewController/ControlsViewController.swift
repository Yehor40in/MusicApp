//
//  ControlsViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer



class ControlsViewController: UIViewController {
    
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    var delegate: ControlsControllerDelegate!
    var player: MPMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateDetails()
    }
    

    @IBAction func backwardTapped(_ sender: Any) {
        delegate.backward()
        updateDetails()
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        delegate.playPause()
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        delegate.forward()
        updateDetails()
    }
    
    
    func updateDetails() {
        
        if let item = player.nowPlayingItem {
            songName.text = item.title
            artist.text = item.artist
        } else {
            songName.text = "Not Playing"
            artist.text = "Not Playing"
        }
    }
}
