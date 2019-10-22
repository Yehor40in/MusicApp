//
//  UIViewHelper.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 10/10/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation
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

extension Notification.Name {
    static var trackChanged: Notification.Name {
        return Notification.Name("trackChanged")
    }
    static var trackResumed: Notification.Name {
        return Notification.Name("trackResumed")
    }
    static var trackPaused: Notification.Name {
        return Notification.Name("trackPaused")
    }
}
