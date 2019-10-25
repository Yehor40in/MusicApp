//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/25/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    // MARK: - Properties
    private var items: [Playlist]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        items = getPlaylists()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    // MARK: - Utilities
    func getPlaylists() -> [Playlist] {
        return []
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
