//
//  MusicListController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import AVFoundation


class MusicListController: UIViewController {
    
    //MARK: - Properties
    var items: [MusicItem]?
    var sectionTitles: [String]?
    
    var player: AVAudioPlayer!
    var paused = false
    
    var playingRow: Int?
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var playingCover: UIImageView!
    @IBOutlet weak var playingName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = preparedItems(from: getItems(), by: .title)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        playingName.text = "Not Playing"
        playingCover.image = UIImage(named: "defaultmusicicon")
        playingCover.layer.cornerRadius = 8
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    //MARK: - Actions
    @IBAction func playButtonTapped(_ sender: Any) {
        if player == nil {
            self.playRandomSong()
            
        } else if paused {
            self.paused = false
            self.player.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: .none), for: .normal)
            
        } else {
            self.paused = true
            self.player.pause()
            self.playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: .none), for: .normal)
        }
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        playRandomSong()
    }
    
    
    @IBAction func sortTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: "Sort by", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Artist", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items!, by: .artist)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Title", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items!, by: .title)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Recently Added", style: .default, handler: { (_) in
            self.items = self.preparedItems(from: self.items!, by: .date)
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


extension MusicListController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as! MusicListCell
        cell.item = items?[indexPath.row]
        
        return cell
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}

