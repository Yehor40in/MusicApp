//
//  MusicListController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit


class MusicListController: UIViewController {
    
    //MARK: - Properties
    var items: [Character: [MPMediaItem]]?
    var sectionTitles: [String]?
    
    //var player: AVAudioPlayer!
    var player: MPMusicPlayerController?
    var query: MPMediaQuery?
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var playingCover: UIImageView!
    @IBOutlet weak var playingName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKCloudServiceController.requestAuthorization { status in
            if status == .authorized {
                self.query = MPMediaQuery.songs()
                self.items = self.preparedItems(from: (self.query?.items)!, by: .title)
                self.preparePlayer()
                
                DispatchQueue.main.async {
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                }
            }
        }
        
        playingName.text = Constants.songLabelPlaceholder
        playingCover.image = UIImage(named: Constants.musicIconPlaceholderName)
        playingCover.layer.cornerRadius = Constants.cornerRadiusPlaceholder
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        playingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDetails(_:))))
    }
    

    
    //MARK: - Actions
    @IBAction func playButtonTapped(_ sender: Any) {
        
        if player!.isPreparedToPlay && !forwardButton.isEnabled {
            self.playRandomSong()
            
        } else if player?.playbackState == .paused {
            self.player?.play()
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            
        } else {
            self.player?.pause()
            self.playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        self.playRandomSong()
    }
    
    
    @IBAction func sortTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: "Sort by", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.green
        
        actionSheet.addAction(UIAlertAction(title: "Artist", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: (self.query?.items)!, by: .artist)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Title", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: (self.query?.items)!, by: .title)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Recently Added", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: (self.query?.items)!, by: .date)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(actionSheet, animated: true, completion: nil)
    }

}
