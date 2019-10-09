//
//  PlayingViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/9/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayingViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var songProgress: UISlider!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    //MARK: - Properties
    var preparedData: PreparedInfo!
    var player: MPMusicPlayerController!
    
    var paused = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cover.layer.cornerRadius = 10
        
        if let temp = preparedData {
            self.cover.image = temp.cover
            self.artist.text = temp.artist
            self.name.text = temp.title
            self.player = temp.player
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cover.frame = CGRect(x: self.cover.frame.origin.x, y: self.cover.frame.origin.y, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.4)
        })
    }
    
    
    func updateView() {
        // TODO: Update view with currently playing item after user skipped to next/previous
    }
    
    
    //MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if paused {
            self.player.play()
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            self.paused = false
        } else {
            self.player.pause()
            self.playButton.setImage(UIImage(named: "play"), for: .normal)
            self.paused = true
        }
    }
    
    
    @IBAction func backwardTapped(_ sender: Any) {
        self.player.skipToPreviousItem()
        updateView()
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        self.player.skipToNextItem()
        updateView()
    }
    
    //TODO: let MusicListController know if user skipped to next/previous song so it can update nowPlaying information
    
}
