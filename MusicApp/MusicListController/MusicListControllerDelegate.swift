//
//  MusicListControllerDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/2/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit


extension MusicListController: UITableViewDelegate {
    //MARK: - TableViewDelegate
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.setPlayingItem(for: indexPath)
        self.player.play()
        self.updatePlayingView()
    }
}

extension MusicListController: PlayingViewControllerDelegate {
    //MARK: - PlayingViewControllerDelegate
    
    func setStartAnimPosition(sender: PlayingViewController) {
        sender.view.layoutIfNeeded()
        
        sender.coverImageView.layer.cornerRadius = 8
        sender.coverViewTopConstraint.constant = self.tableView.frame.height + (self.navigationController?.navigationBar.frame.height)!
        sender.coverImageBottomConstraint.constant = (sender.coverView.frame.height - sender.prepared.outPosition.imageOutBottom)
        sender.coverImageTrailingConstraint.constant = (sender.coverView.frame.width - sender.prepared.outPosition.imageOutTrailing)
    }
}
