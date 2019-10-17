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
    var items: [Character: [MusicItem]]?
    var sectionTitles: [String]?
    
    var player: AVAudioPlayer!
    var paused = true
    
    var playingKeyIndex: Int?
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
        
        self.items = preparedItems(from: getItems())
        self.sectionTitles = items?.keys.map { String($0) }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        playingName.text = "Not Playing"
        playingCover.image = UIImage(named: "defaultmusicicon")
        playingCover.layer.cornerRadius = 8
    }
    
    //sample data for now
    func getItems() -> [MusicItem] {
        
        return [
            MusicItem(artist: "Bensound", name: "Dubstep", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-dubstep", ofType: "mp3")!)),
            MusicItem(artist: "Bensound", name: "Energy", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-energy", ofType: "mp3")!)),
            MusicItem(artist: "Bensound", name: "Epic", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-epic", ofType: "mp3")!)),
            MusicItem(artist: "Bensound", name: "Once Again", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-onceagain", ofType: "mp3")!)),
        ]
        
    }
    
    //MARK: - Utilities
    func preparedItems(from raw: [MusicItem]) -> [Character: [MusicItem]] {
        var prepared = [Character: [MusicItem]]()
        
        for item in raw {
            guard let key = item.name.first else { continue }
            
            if var existedArray = prepared[key] {
                existedArray.append(item)
            } else {
                prepared[key] = [item]
            }
        }
        return prepared
    }
    
    
    func prepareMusicAndSession(for index: Int, at key: Character) {
        
        let item = items?[key]![index]
        
        player = try! AVAudioPlayer(contentsOf: item!.location)
        player.delegate = self
        player.prepareToPlay()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch let sessionError {
            print(sessionError)
        }
        self.forwardButton.isEnabled = true
    }
    
    
    func updatePlayingView(with object: MusicItem) {
        
        //self.playingCover.image = UIImage(named: object.image!)
        self.playingName.text = object.name
        self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: .none), for: .normal)
    }
    
    
    func playRandomSong() {
        
        let randomSection = Int.random(in: 0..<sectionTitles!.count)
        let key = Character(sectionTitles![randomSection])
        
        let row = Int.random(in: 0..<(items?[key]?.count)!)
        
        prepareMusicAndSession(for: row, at: key)
        self.player?.play()
        updatePlayingView(with: (items?[key]?[row])!)
    }

    
    //MARK: - Actions
    @IBAction func playButtonTapped(_ sender: Any) {
        if player == nil {
            playRandomSong()
            
        } else if paused {
            self.paused = false
            self.player?.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: .none), for: .normal)
            
        } else {
            self.paused = true
            self.player?.pause()
            self.playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: .none), for: .normal)
        }
    }
    
    
    @IBAction func forwardTapped(_ sender: Any) {
        playRandomSong()
    }

}


extension MusicListController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles!.count
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Character(sectionTitles![section])
        return items?[key]!.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as! MusicListCell
        let key = Character(sectionTitles![indexPath.section])
        
        if let item = items![key] {
            cell.item = item[indexPath.row]
        }
        return cell
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles?[section]
    }
}

