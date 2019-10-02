//
//  MusicListModel.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit


class MusicListModel : NSObject {
    
    override init() {
    
        //test sample data
        self.items = [
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Alpha")   ],
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Bravo")   ],
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Charlie") ],
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Delta")   ],
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Echo")    ],
            [ MusicItem(image: "pooh", artist: "The Prodigy", name: "Foxtrot") ]
        ]
        
        self.sectionTitles = ["A", "B", "C", "D", "E", "F"]
        
        super.init()
    }
    
    
    func prepareItems() {
        //
    }
    
}


//MARK: - TableViewDataSource
extension MusicListModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionTitles[section])
    }
    
    
    private func sectionIndexTitles(for tableView: UITableView) -> [Character]? {
        return sectionTitles
    }
    
}
