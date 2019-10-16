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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateDetails(_:)), name: Notification.Name("trackChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlay(_:)), name: Notification.Name("trackPaused"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePaused(_:)), name: Notification.Name("trackResumed"), object: nil)
    }
    

    @IBAction func backwardTapped(_ sender: Any) {
        delegate.backward()
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        delegate.playPause()
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        delegate.forward()
    }
    
    
    @objc func handlePaused(_ notification: Notification) {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    
    @objc func handlePlay(_ notification: Notification) {
        playButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
    
    @objc func updateDetails(_ notification: Notification) {
        
        if let item = notification.userInfo!["playingItem"] as? MPMediaItem {
            songName.text = item.title
            artist.text = item.artist
        } else {
            songName.text = "Not Playing"
            artist.text = "Not Playing"
        }
        
        if let state = notification.userInfo!["state"] as? MPMusicPlaybackState {
            switch state {
            case .paused:
                playButton.setImage(UIImage(named: "play"), for: .normal)
            case .playing:
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            default:
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }
}
