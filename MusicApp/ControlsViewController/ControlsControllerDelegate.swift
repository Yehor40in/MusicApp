//
//  ControlsViewControllerDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/15/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer

protocol ControlsControllerDelegate: class {
    func updateCover(with item: MPMediaItem?)
}
