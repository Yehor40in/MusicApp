//
//  SettingsManager.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 12/5/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import Foundation

final class SettingsManager {
    enum AppKeys {
        static var resetKey: String = "APP_RESET_KEY"
        static var versionKey: String = "APP_VERSION_KEY"
    }
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: AppKeys.resetKey) {
            if let identifier = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: identifier)
            }
            _ = PlaylistManager.playlistIDs?.map {
                PlaylistManager.deletePlaylist(with: $0)
            }
            PlaylistManager.playlistIDs = nil
        }
    }
    class func setVersion() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        UserDefaults.standard.set(version, forKey: AppKeys.versionKey)
    }
}
