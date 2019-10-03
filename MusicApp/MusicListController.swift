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
    var items: [Character: [MusicItem]]!
    var sectionTitles: [String]!
    
    var player: AVAudioPlayer!
    var isPLaying: Bool = false
    
    var playingKeyIndex: Int!
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
        
        self.items = preparedItems(from: getItems())
        self.sectionTitles = items.keys.map { String($0) }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        playingName.text = "Not Playing"
        playingCover.image = UIImage(named: "defaultmusicicon")
        playingCover.layer.cornerRadius = 8

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    
    func preparedItems(from raw: [MusicItem]) -> [Character: [MusicItem]] {
        
        let temp = raw.sorted { $0.name < $1.name }
        var prepared = [Character: [MusicItem]]()
        
        for item in temp {
            let key = item.name.first!
            if let _ = prepared[key] {
                prepared[key]!.append(item)
            } else {
                prepared[key] = [MusicItem]()
                prepared[key]!.append(item)
            }
        }
        return prepared
    }
    
    
    func prepareMusic(for index: Int, at key: Character) {
        
        let item = items[key]![index]
        
        player = try! AVAudioPlayer(contentsOf: item.location)
        player.delegate = self
        player.prepareToPlay()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        } catch let sessionError {
            print(sessionError)
        }
    }
    
    
    func updatePlayingView(with object: MusicItem) {
        
        //self.playingCover.image = UIImage(named: object.image!)
        self.playingName.text = object.name
        self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: .none), for: .normal)
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
