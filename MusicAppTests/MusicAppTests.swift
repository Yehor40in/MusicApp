//
//  MusicAppTests.swift
//  MusicAppTests
//
//  Created by Yehor Sorokin on 11/11/19.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import XCTest
import Foundation
@testable import MusicApp

class MusicAppTests: XCTestCase {
    private var player: MusicPlayer!
    private var ctrl: MusicListController!
    private var index: Int!
    // MARK: - Setup
    override func setUp() {
        player = MusicPlayer.shared
        player.setupItems(by: .title)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        ctrl = storyboard.instantiateViewController(withIdentifier: "MusicList") as? MusicListController
    }
    override func tearDown() {
        player = nil
        ctrl = nil
    }
    // MARK: - MusicPlayer Tests
    func testUpNextEmpty() {
        player.setUpNext()
        XCTAssertNotEqual(player.upNext, [], "Failed to calculate next in queue!")
    }
    func testUpNextForward() {
        player.setUpNext()
        let temp = player.nowPlayingItem!
        player.goToNextInQueue()
        XCTAssert(!player.upNext.contains(temp), "Next in queue contains passed by item!")
    }
    func testUpNextBackward() {
        player.setUpNext()
        let temp = player.nowPlayingItem!
        player.goToPreviousInQueue()
        XCTAssert(player.upNext.contains(temp), "Next in queue does not contain rewinded item!")
    }
    func testCurrentIndexOutOfRangeEnd() {
        player.setUpNext()
        let index = player.getItems.endIndex - 1
        player.nowPlayingItem = player.getItems[index]
        player.cIndex = index
        player.goToNextInQueue()
        XCTAssertEqual(player.cIndex, 0, "Trying to go futher than last index should return zero index!")
    }
    func testCurrentIndexOutOfRangeStart() {
        player.setUpNext()
        let index = player.getItems.startIndex
        player.nowPlayingItem = player.getItems[index]
        player.cIndex = index
        player.goToPreviousInQueue()
        let end = player.getItems.endIndex - 1
        XCTAssertEqual(player.cIndex, end, "Trying to go earlier than first index should return last index!")
    }
    func testCurrentIndexForward() {
        player.playRandomSong()
        player.setUpNext()
        player.goToNextInQueue()
        let tempIndex = player.getItems.firstIndex(of: player.nowPlayingItem!)!
        XCTAssertEqual(
            player.cIndex,
            tempIndex,
            "Index of next playing song differs from next in queue index!"
        )
    }
    func testCurrentIndexBackward() {
        player.playRandomSong()
        player.setUpNext()
        player.goToPreviousInQueue()
        let tempIndex = player.getItems.firstIndex(of: player.nowPlayingItem!)!
        XCTAssertEqual(
            player.cIndex,
            tempIndex,
            "Index of next playing song differs from prevoius in queue index!"
        )
    }
    // MARK: - PlaylistManager Tests
    func testMakePlaylists() {
        let temp = PlaylistManager.makePlaylists()
        XCTAssertNotEqual(temp.count, 0, "Recieved set should have at least favorites in it!")
    }
    // MARK: - MusicListController Tests
    func testValidPath() {
        let path = IndexPath(row: -1, section: -1)
        XCTAssert(!ctrl.isValid(path), "This path should be invalid!")
    }
}
