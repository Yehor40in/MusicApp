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
    var items: [MPMediaItem]!
    var sectionTitles: [String]!
    
    //var player: AVAudioPlayer!
    var player: MPMusicPlayerController!
    var query: MPMediaQuery!
    var paused = false
    
    var playingRow: Int!
    
    
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
            switch status {
            case .authorized:
                self.query = MPMediaQuery.songs()
                self.items = self.preparedItems(from: self.query.items!, by: .title)
                print(self.query!)
                self.preparePlayer()
                
                DispatchQueue.main.async {
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                }
                
            case .denied:
                print("User denied library access!")
                
            case .restricted:
                print("It happens ..")
                
            case .notDetermined:
                print("Who knows ..")
                
            @unknown default:
                fatalError("Must grant permissions!")
            }
        }
        
        playingName.text = "Not Playing"
        playingCover.image = UIImage(named: "defaultmusicicon")
        playingCover.layer.cornerRadius = 8
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    //MARK: - Actions
    @IBAction func playButtonTapped(_ sender: Any) {
        
        if player.isPreparedToPlay && !forwardButton.isEnabled {
            self.playRandomSong()
            
        } else if paused {
            self.paused = false
            self.player.play()
            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
            
        } else {
            self.paused = true
            self.player.pause()
            self.playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        self.playRandomSong()
    }
    
    
    @IBAction func sortTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: "Sort by", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Artist", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items, by: .artist)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Title", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items, by: .title)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Recently Added", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items, by: .date)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
