//
//  PlayingViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var fakeBackground: UIImageView!
    // MARK: - Constraints
    @IBOutlet weak var coverImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    // MARK: - Properties
    var prepared: PreparedData?
    var player: MPMusicPlayerController?
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
            let img = player?.nowPlayingItem?.artwork?.image(at: self.coverImageView!.bounds.size)
            coverImageView.image = img ?? UIImage(named: Constants.musicIconPlaceholderName)
        }
        chevron.isHidden = true
        NotificationCenter.default.post(
            name: Constants.trackChangedNotification,
            object: nil,
            userInfo: [
                "playingItem": player?.nowPlayingItem as Any,
                "state": player?.playbackState as Any,
                "progress": player?.currentPlaybackTime as Any
            ]
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        coverViewTopConstraint.constant = (prepared?.outPosition.coverOut)!
        coverImageBottomConstraint.constant = coverView.frame.height - (prepared?.outPosition.imageOutBottom)!
        coverImageTrailingConstraint.constant = coverView.frame.width - (prepared?.outPosition.imageOutTrailing)!
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
    func animateCoverIn() {
        coverViewTopConstraint.constant = 50
        coverImageBottomConstraint.constant = 20
        coverImageTrailingConstraint.constant = 20
        let verticalOffset = view.frame.height * 0.05
        let horizontalOffset = view.frame.width * 0.05
        backgroundTopConstraint.constant = verticalOffset
        backgroundLeadingConstraint.constant = horizontalOffset
        backgroundBottomConstraint.constant = verticalOffset
        backgroundTrailingConstraint.constant = horizontalOffset
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.chevron.isHidden = false
        })
    }
    func animateCoverOut() {
        coverViewTopConstraint.constant = (prepared?.outPosition.coverOut)!
        coverImageBottomConstraint.constant = (coverView.frame.height - (prepared?.outPosition.imageOutBottom)!)
        coverImageTrailingConstraint.constant = (coverView.frame.width  - (prepared?.outPosition.imageOutTrailing)!)
        backgroundTopConstraint.constant = 0
        backgroundLeadingConstraint.constant = 0
        backgroundBottomConstraint.constant = 0
        backgroundTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    func update(with obj: MPMediaItem?) {
        let img = obj?.artwork?.image(at: self.coverImageView.bounds.size)
        coverImageView.image = img ?? UIImage(named: Constants.musicIconPlaceholderName)
        NotificationCenter.default.post(
            name: Constants.trackChangedNotification,
            object: nil,
            userInfo: [
                "playingItem": obj as Any,
                "progress": player?.currentPlaybackTime as Any
            ]
        )
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controls = segue.destination as? ControlsViewController {
            controls.delegate = self
        }
    }

}
