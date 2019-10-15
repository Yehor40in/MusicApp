//
//  PlayingViewDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/15/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import UIKit

extension PlayingViewController: UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
