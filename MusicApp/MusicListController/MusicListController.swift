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

final class MusicListController: UIViewController {
    // MARK: - Properties
    private var items: [Character: [MPMediaItem]]?
    private var sectionTitles: [String]?
    private var player: MusicPlayer?
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var playingView: UIView!
    @IBOutlet private weak var playingCover: UIImageView!
    @IBOutlet private weak var playingName: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
        playingName.text = Config.songLabelPlaceholder
        playingCover.image = UIImage(named: Config.musicIconPlaceholderName)
        playingCover.layer.cornerRadius = Config.cornerRadiusPlaceholder
        playingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDetails(_:))))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlayingView()
    }
    // MARK: - Actions
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let playerPrepared = player?.isPrepared else { return }
        if playerPrepared && !forwardButton.isEnabled {
            playRandomSong()
        } else if player?.playbackState == .paused {
            player?.play()
            playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
        } else {
            player?.pause()
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
        }
    }
    @IBAction func forwardTapped(_ sender: Any) {
        player?.updateUpNext(forward: true)
        playRandomSong()
    }
    @IBAction func sortTapped(_ sender: Any) {
        let actionSheet = UIAlertController(
            title: nil,
            message: Config.sortMessagePlaceholder,
            preferredStyle: .actionSheet
        )
        actionSheet.view.tintColor = UIColor.green
        actionSheet.addAction(
            UIAlertAction(title: Config.sortArtistPlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player?.query.items, by: .artist)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(
            UIAlertAction(title: Config.sortTitlePlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player?.query.items, by: .title)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(
            UIAlertAction(title: Config.recentlyAddedPlaceholder, style: .default, handler: { [weak self] (_) in
                self?.items = self?.preparedItems(from: self?.player?.query.items, by: .date)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: Config.dismissMessage, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension MusicListController {
    // MARK: - Utilities
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
        return prepared
    }
    func preparePlayer() {
        player = MusicPlayer.shared
    }
    func setPlayingItem(for path: IndexPath) {
        guard let sectionTitles = self.sectionTitles else { return }
        let key = Character(sectionTitles[path.section])
        player?.nowPlayingItem = items?[key]?[path.row]
    }
    func checkAuthorization() {
        SKCloudServiceController.requestAuthorization {[weak self] status in
            if status == .authorized {
                self?.preparePlayer()
                guard let data = self?.player?.query.items else { return }
                self?.items = self?.preparedItems(from: data, by: .title)
            }
        }
    }
    func updatePlayingView() {
        if let object = player?.nowPlayingItem {
            let img = object.artwork?.image(at: playingCover.bounds.size)
            playingCover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            playingName.text = object.title
            switch self.player?.playbackState {
            case .paused:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            case .playing:
                playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            default:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            }
            forwardButton.isEnabled = true
        }
    }
    func playRandomSong() {
        if let titles = sectionTitles, let values = items {
            let sec = Int.random(in: 0..<titles.count)
            let key = titles[sec].first!
            guard let set = values[key] else { return }
            let row = Int.random(in: 0..<set.count)
            setPlayingItem(for: IndexPath(row: row, section: sec))
            player?.play()
            updatePlayingView()
        }
    }
    @objc func showDetails(_ sender: UITapGestureRecognizer!) {
        if let details = storyboard?.instantiateViewController(withIdentifier: "detailInfo") as? PlayingViewController {
            guard let navHeight = navigationController?.navigationBar.frame.height else { return }
            let pos = Position(
                coverOut: tableView.frame.height + navHeight,
                imageOutBottom: playingCover.frame.height + playingCover.frame.origin.y,
                imageOutTrailing: playingCover.frame.width + playingCover.frame.origin.x
            )
            if let img = self.view.makeScreenshot() {
                details.prepared = PreparedData(image: img, outPosition: pos)
                details.delegate = self
                details.modalPresentationStyle = .fullScreen
                present(details, animated: false)
            }
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as? MusicListCell {
            cell.item = items?[key]?[indexPath.row]
            return cell
        }
        return UITableViewCell()
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
        player?.updateUpNext(forward: true)
        setPlayingItem(for: indexPath)
        player?.play()
        updatePlayingView()
    }
}

extension MusicListController: PlayingViewControllerDelegate {
    // MARK: - PlayingViewControllerDelegate
    func commitChanges() {
        updatePlayingView()
    }
}
