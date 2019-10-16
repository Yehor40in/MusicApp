//
//  MusicListControllerDataSource.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit


extension MusicListController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles!.count
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Character(sectionTitles![section])
        return self.items![key]!.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = Character(sectionTitles![indexPath.section])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as! MusicListCell
        cell.item = self.items![key]![indexPath.row]
        
        return cell
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles![section]
    }
}
