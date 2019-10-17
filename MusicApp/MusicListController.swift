//
//  MusicListController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
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


extension MusicListController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles!.count
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Character(sectionTitles![section])
        return items[key]?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as! MusicListCell
        let key = Character(sectionTitles![indexPath.section])
        
        if let item = items?[key] {
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

