//
//  UIViewHelper.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

extension UIView {
    func makeScreenshot() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
}

class Artwork: Codable {
    let imageData: Data?
    init(with image: UIImage?) {
        self.imageData = image?.pngData()
    }
    func getImage() -> UIImage? {
        if let imageData = self.imageData {
            let image = UIImage(data: imageData)
            return image
        } else {
            return UIImage(named: Config.playlistIconPlaceholder)
        }
    }
}

class MediaItem: Codable {
    var title: String
    var artist: String
    var storeID: String
    var artwork: Artwork
    init(with item: MPMediaItem?) {
        self.title = item?.title ?? Config.unknownPlaceholder
        self.artist = item?.artist ?? Config.unknownPlaceholder
        let art = item?.artwork?.image(at: CGSize(width: 100, height: 100))
        self.artwork = Artwork(with: art)
        self.storeID = item?.playbackStoreID ?? ""
    }
}
