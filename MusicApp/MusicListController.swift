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
    var items: [Character: [MusicItem]]!
    var sectionTitles: [String]!
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var playingCover: UIImageView!
    @IBOutlet weak var playingName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let raw = getItems()
        self.items = preparedItems(from: raw)
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
            MusicItem(artist: "The Prodigy", name: "Echo"),
            MusicItem(artist: "The Prodigy", name: "Alpha"),
            MusicItem(artist: "The Prodigy", name: "Bravo"),
            MusicItem(artist: "The Prodigy", name: "Foxtrot"),
            MusicItem(artist: "The Prodigy", name: "Charlie"),
            MusicItem(image: "pooh", artist: "The Prodigy", name: "Delta")
        ]
        
    }
    
    
    func preparedItems(from raw: [MusicItem]) -> [Character: [MusicItem]] {
        
        let temp = raw.sorted(by: { $0.name < $1.name })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
