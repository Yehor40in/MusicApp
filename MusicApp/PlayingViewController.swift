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
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var fakeBackground: UIImageView!
    
    
    //MARK: - Constraints
    @IBOutlet weak var scrollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    
    
    //MARK: - Properties
    var prepared: PreparedData!
    var player: MPMusicPlayerController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let temp = prepared {
            fakeBackground.image = temp.image
            player = temp.player
            coverImageView.image = player.nowPlayingItem?.artwork!.image(at: self.coverImageView!.bounds.size) ?? UIImage(named: "defaultmusicicon")
        }
        
        scrollTopConstraint.constant = self.view.frame.height * 0.9
        coverLeadingConstraint.constant = 20
        coverTrailingConstraint.constant = self.view.frame.width * 0.8
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        animateCoverIn()
    }
    
    
    //MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        animateCoverOut()
    }
    
    
    //MARK: - Utilities
    func animateCoverIn() {
        scrollTopConstraint.constant = 50
        coverLeadingConstraint.constant = 50
        coverTrailingConstraint.constant = 50
        
        backgroundTopConstraint.constant = 10
        backgroundLeadingConstraint.constant = 10
        backgroundBottomConstraint.constant = 10
        backgroundTrailingConstraint.constant = 10
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    func animateCoverOut() {
        scrollTopConstraint.constant = self.view.frame.height
        coverLeadingConstraint.constant = 20
        coverTrailingConstraint.constant = self.view.frame.width * 0.8
        
        backgroundTopConstraint.constant = 0
        backgroundLeadingConstraint.constant = 0
        backgroundBottomConstraint.constant = 0
        backgroundTrailingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 */

}
