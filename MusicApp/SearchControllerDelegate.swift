//
//  SearchControllerDelegate.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/31/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer

protocol SearchControllerDelegate: class {
    func getCodableItems(form standard: [MPMediaItem]?)
}
