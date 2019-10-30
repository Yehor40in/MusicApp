//
//  PlayingViewUpdater.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/28/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

class PLayingViewUpdater {
    func updatePlayingView(
        _ playingCover: inout UIImageView,
        _ playingName: inout UILabel,
        _ playButton: inout UIButton,
        _ forwardButton: inout UIButton
    ) {
        if let object = MusicPlayer.shared.nowPlayingItem {
            let img = object.artwork?.image(at: playingCover.bounds.size)
            playingCover.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
            playingName.text = object.title
            switch MusicPlayer.shared.playbackState {
            case .paused:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            case .playing:
                playButton.setImage(UIImage(named: Config.pauseImagePlaceholder), for: .normal)
            default:
                playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
            }
            forwardButton.isEnabled = true
        } else {
            playingCover.image = UIImage(named: Config.musicIconPlaceholderName)
            playingName.text = Config.songLabelPlaceholder
            playButton.setImage(UIImage(named: Config.playImagePlaceholder), for: .normal)
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
