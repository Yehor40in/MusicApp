//
//  PlayingViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

final class PlayingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var chevron: UIButton!
    @IBOutlet private weak var fakeBackground: UIImageView!
    // MARK: - Constraints
    @IBOutlet private weak var coverImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var coverImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var coverViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backgroundTrailingConstraint: NSLayoutConstraint!
    // MARK: - Properties
    var prepared: PreparedData?
    private var player: MPMusicPlayerController?
    weak var delegate: PlayingViewControllerDelegate?
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let temp = prepared {
            fakeBackground.image = temp.image
            player = temp.player
            let img = player?.nowPlayingItem?.artwork?.image(at: coverImageView.bounds.size)
            coverImageView.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
        }
        chevron.isHidden = true
        update(with: player?.nowPlayingItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        setupCover()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCoverIn()
    }
    // MARK: - Actions
    @IBAction func chevronTapped(_ sender: Any) {
        chevron.isHidden = true
        delegate?.commitChanges()
        animateCoverOut()
    }
    // MARK: - Utilities
    func setupCover() {
        if let out = prepared?.outPosition.coverOut,
        let bottom = prepared?.outPosition.imageOutBottom,
        let trailing = prepared?.outPosition.imageOutTrailing {
            coverViewTopConstraint.constant = out
            coverImageBottomConstraint.constant = coverView.frame.height - bottom
            coverImageTrailingConstraint.constant = coverView.frame.width - trailing
        }
    }
    func update(with item: MPMediaItem?) {
        let img = item?.artwork?.image(at: coverImageView.bounds.size)
        coverImageView.image = img ?? UIImage(named: Config.musicIconPlaceholderName)
        NotificationCenter.default.post(
            name: Notification.Name.trackChanged,
            object: nil,
            userInfo: [
                Config.playingItemKey: item as Any,
                Config.stateKey: player?.playbackState as Any,
                Config.progressKey: player?.currentPlaybackTime as Any
            ]
        )
    }
    func animateCoverIn() {
        coverViewTopConstraint.constant = Config.topConstant
        coverImageBottomConstraint.constant = Config.sideConstant
        coverImageTrailingConstraint.constant = Config.sideConstant
        let verticalOffset = view.frame.height * Config.sideMultiplier
        let horizontalOffset = view.frame.width * Config.sideMultiplier
        backgroundTopConstraint.constant = verticalOffset
        backgroundLeadingConstraint.constant = horizontalOffset
        backgroundBottomConstraint.constant = verticalOffset
        backgroundTrailingConstraint.constant = horizontalOffset
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.view.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.chevron.isHidden = false
        })
    }
    func animateCoverOut() {
        coverViewTopConstraint.constant = (prepared?.outPosition.coverOut)!
        coverImageBottomConstraint.constant = coverView.frame.height - (prepared?.outPosition.imageOutBottom)!
        coverImageTrailingConstraint.constant = coverView.frame.width  - (prepared?.outPosition.imageOutTrailing)!
        backgroundTopConstraint.constant = 0
        backgroundLeadingConstraint.constant = 0
        backgroundBottomConstraint.constant = 0
        backgroundTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        })
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controls = segue.destination as? ControlsViewController {
            controls.delegate = self
        }
    }
}

extension PlayingViewController: ControlsControllerDelegate {
    // MARK: - ControlsControllerDelegate
    func backward() {
        player?.skipToPreviousItem()
        update(with: player?.nowPlayingItem)
    }
    func playPause() {
        switch player?.playbackState {
        case .paused:
            player?.play()
            NotificationCenter.default.post(name: Notification.Name.trackResumed, object: nil)
        case .playing:
            player?.pause()
            NotificationCenter.default.post(name: Notification.Name.trackPaused, object: nil)
        default:
            return
        }
    }
    func forward() {
        player?.skipToNextItem()
        update(with: player?.nowPlayingItem)
    }
}
