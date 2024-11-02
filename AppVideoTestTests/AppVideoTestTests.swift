//
//  AppVideoTestTests.swift
//  AppVideoTestTests
//
//  Created by Jae hyung Kim on 10/28/24.
//

import XCTest
@testable import AppVideoTest

final class AppVideoTestTests: XCTestCase {
    
    var viewController: CustomViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = CustomViewController()
        viewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testSetVideo() throws {
        // 테스트용 비디오 URL
        let testURL = Bundle.main.url(forResource: "sample", withExtension: "mp4")!
        
        viewController.setVideo(testURL)
        
        // 비디오 플레이어가 초기화되었는지 확인
        XCTAssertNotNil(viewController.videoPlayer)
        
        // 비디오가 일시정지 상태로 시작되는지 확인
        XCTAssertFalse(viewController.isPlaying, "Video should initially be paused.")
    }
}


