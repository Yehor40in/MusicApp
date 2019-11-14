//
//  MusicListController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer
import StoreKit

final class MusicListController: ViewManager {
    // MARK: - Outlets
    @IBOutlet private weak var sortButton: UIBarButtonItem!
    // MARK: - Properties
    private var items: [Character: [MPMediaItem]]?
    private var sectionTitles: [String]?
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
        playingCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
        playingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDetails(_:))))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("Your Music", comment: "Navigation item title")
        sortButton.title = NSLocalizedString("Sort", comment: "Sort placeholder")
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlayingView(nil)
    }
    // MARK: - Actions
    @IBAction func sortTapped(_ sender: Any) {
        let actionSheet = UIAlertController(
            title: nil,
            message: Config.sortMessagePlaceholder,
            preferredStyle: .actionSheet
        )
        actionSheet.view.tintColor = UIColor.systemPink
        actionSheet.addAction(
            UIAlertAction(title: Config.sortArtistPlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player.rawItems, by: .artist)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(
            UIAlertAction(title: Config.sortTitlePlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player.rawItems, by: .title)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(
            UIAlertAction(title: Config.recentlyAddedPlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player.rawItems, by: .date)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    // MARK: - Utilities
    // swiftlint:disable cyclomatic_complexity
    func preparedItems(from raw: [MPMediaItem]?, by option: SortOption) -> [Character: [MPMediaItem]] {
        var prepared = [Character: [MPMediaItem]]()
        sectionTitles = [String]()
        switch option {
        case .artist:
            guard let temp = raw else { return [:] }
            for item in temp {
                guard let char = item.artist?.first else { return [:] }
                if let titles = sectionTitles {
                    if !titles.contains(String(char)) { sectionTitles?.append(String(char)) }
                }
            }
            if let sectionTitles = sectionTitles?.sorted() {
                for char in sectionTitles {
                    prepared[Character(char)] = raw?.filter { return $0.artist?.first == Character(char) }
                }
            }
        case .title:
            guard let temp = raw else { return [:] }
            for item in temp {
                guard let char = item.title?.first else { return [:] }
                if let titles = sectionTitles {
                    if !titles.contains(String(char)) { sectionTitles?.append(String(char)) }
                }
            }
            if let sectionTitles = sectionTitles?.sorted() {
                let temp = Set(sectionTitles)
                for char in temp {
                    prepared[Character(char)] = raw?.filter { return $0.title?.first == Character(char) }
                }
            }
        case .date:
            if let temp = raw?.sorted(by: { $0.dateAdded < $1.dateAdded }) {
                sectionTitles?.append(String(" "))
                prepared[" "] = temp
            }
        }
        player.setupItems(by: option)
        return prepared
    }
    func setPlayingItem(for path: IndexPath) {
        player.setupItems(by: .title)
        player.setupQueue(with: MPMediaQuery.songs())
        if isValid(path) {
            let key = Character(sectionTitles![path.section])
            player.nowPlayingItem = items?[key]?[path.row]
        }
    }
    func isValid(_ path: IndexPath) -> Bool {
        guard let titles = sectionTitles else { return false}
        let key = Character(titles[path.section])
        guard path.section < titles.count && path.section >= 0 else { return false }
        guard let temp = items?[key] else { return false }
        guard path.row < temp.count && path.row >= 0 else { return false}
        return true
    }
    func checkAuthorization() {
        SKCloudServiceController.requestAuthorization {[weak self] status in
            if status != .authorized {
                return
            }
            guard let data = self?.player.getItems else { return }
            self?.items = self?.preparedItems(from: data, by: .title)
        }
    }
}

extension MusicListController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Character(sectionTitles![section])
        return items?[key]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionTitles = sectionTitles else { return UITableViewCell() }
        let key = Character(sectionTitles[indexPath.section])
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MusicListCell",
            for: indexPath
        ) as? MusicListCell else { return UITableViewCell() }
        cell.item = items?[key]?[indexPath.row]
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles?[section]
    }
}

extension MusicListController: UITableViewDelegate {
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setPlayingItem(for: indexPath)
        player.play()
    }
}
