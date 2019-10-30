//
//  CreatePlaylistController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/29/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer

final class CreatePlaylistController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var navBar: UINavigationBar!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var chooseCoverButton: UIButton!
    @IBOutlet private weak var playlistNameField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    // MARK: - Properties
    private var items: [MPMediaItem]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        playlistNameField.delegate = self
    }
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension CreatePlaylistController: UITableViewDataSource {
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSongsCell", for: indexPath)
            return cell
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCell", for: indexPath) as? QueueCell {
                guard let items = items else { return UITableViewCell() }
                cell.item = items[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
}

extension CreatePlaylistController: UITableViewDelegate {
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCell.EditingStyle {
        return indexPath.row == 0 ? .insert : .delete
    }
}

extension CreatePlaylistController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
