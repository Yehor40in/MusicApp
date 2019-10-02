//
//  ViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/1/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var model = MusicListModel()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nowPlaying: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView!.dataSource = self.model
    }
}


//MARK: TableView Delegate
extension ViewController: UITableViewDelegate {
    
    //
    
}

