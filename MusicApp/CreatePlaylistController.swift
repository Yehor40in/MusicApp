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
    @IBOutlet private weak var chooseCoverButton: UIButton!
    @IBOutlet private weak var playlistNameField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var choosedPicture: UIImageView!
    // MARK: - Properties
    private let picker = UIImagePickerController()
    private var items: [MPMediaItem]?
    var songs: [MediaItem]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        tableView.dataSource = self
        tableView.delegate = self
        playlistNameField.delegate = self
        picker.delegate = self
    }
    // MARK: - Methods
    func savePlaylist(withTitle title: String, image: UIImage?, songs: [MediaItem]?) -> Bool {
        let artwork = image ?? UIImage(named: Config.playlistIconPlaceholder)
        let media = songs ?? []
        guard var existed = PlaylistManager.getPlaylists() else { return false }
        existed.append(Playlist(image: artwork, name: title, media: media))
        return PlaylistManager.storePlaylists(items: existed)
    }
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func willChoosePicture(_ sender: Any) {
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.view.tintColor = UIColor.systemPink
        actions.addAction(
            UIAlertAction(title: Config.takePicturePlaceholder, style: .default, handler: {[unowned self] (_) in
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true)
            })
        )
        actions.addAction(
            UIAlertAction(title: Config.choosePicturePlaceholder, style: .default, handler: {[unowned self] (_) in
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true)
            })
        )
        actions.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))
        present(actions, animated: true)
    }
    @IBAction func doneTapped(_ sender: Any) {
        guard var title = playlistNameField.text else { return }
        if title.isEmpty { title = Config.defaultPlaylistName }
        if savePlaylist(withTitle: title, image: choosedPicture.image, songs: songs) {
            dismiss(animated: true, completion: nil)
        } else {
            let failAlert = UIAlertController(
                title: "Fail",
                message: "Failed to create playlist",
                preferredStyle: .alert
            )
            failAlert.view.tintColor = UIColor.systemPink
            failAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(failAlert, animated: true)
        }
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
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension CreatePlaylistController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - ImagePicker Delegate
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            choosedPicture.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePlaylistController: SearchControllerDelegate {
    // MARK: - SearchController Delegate
    func getCodableItems(form standard: [MPMediaItem]?) {
        guard let temp = standard else { return }
        songs = temp.map {
            MediaItem(with: $0)
        }
    }
}
