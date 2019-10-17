//
//  MusicListController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class MusicListController: UIViewController {
    //MARK: - Properties
    var items: [Character: [MusicItem]]?
    var sectionTitles: [String]?
    
    
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
            MusicItem(artist: "The Prodigy", name: "Echo"),
            MusicItem(artist: "The Prodigy", name: "Alpha"),
            MusicItem(artist: "The Prodigy", name: "Bravo"),
            MusicItem(artist: "The Prodigy", name: "Foxtrot"),
            MusicItem(artist: "The Prodigy", name: "Charlie"),
            MusicItem(image: "pooh", artist: "The Prodigy", name: "Delta")
        ]
        
    }
    
    
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

}
