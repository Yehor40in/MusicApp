//
//  MusicListControllerUtilities.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/4/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import AVFoundation
import UIKit

extension MusicListController {
    //MARK: - Utilities
    
    //sample data for now
    func getItems() -> [MusicItem] {
        return [
            MusicItem(artist: "Bensound", name: "Dubstep", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-dubstep", ofType: "mp3")!)),
            MusicItem(artist: "Aensound", name: "Energy", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-energy", ofType: "mp3")!)),
            MusicItem(artist: "Censound", name: "Epic", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-epic", ofType: "mp3")!)),
            MusicItem(artist: "Fensound", name: "Once Again", path: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Samples/bensound-onceagain", ofType: "mp3")!))
        ]
    }
    
    
    func preparedItems(from raw: [MusicItem], by option: SortOption) -> [MusicItem] {
        var prepared = [MusicItem]()
        
        self.sectionTitles = [String]()
        
        switch option {
        case .artist:
            prepared = raw.sorted { $0.artist < $1.artist }
            _ = prepared.map {
                sectionTitles!.append(String($0.artist.first!))
            }
        case .title:
            prepared = raw.sorted { $0.name < $1.name }
            _ = prepared.map {
                sectionTitles!.append(String($0.name.first!))
            }
        case .date:
            prepared = raw.sorted { $0.dateAdded < $1.dateAdded }
            for (index, _) in prepared.enumerated() {
                sectionTitles!.append("\(index)")
            }
        }
        return prepared
    }
    
    
    func prepareMusicAndSession(for index: Int) {
        let item = items?[index]
        
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
        self.playingCover.image = UIImage(named: object.image!)
        self.playingName.text = object.name
        self.playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: .none), for: .normal)
    }
    
    
    func playRandomSong() {
        let row = Int.random(in: 0..<(items?.count)!)
        
        prepareMusicAndSession(for: row)
        self.player.play()
        updatePlayingView(with: items![row])
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
