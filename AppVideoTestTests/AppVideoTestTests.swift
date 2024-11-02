//
//  AppVideoTestTests.swift
//  AppVideoTestTests
//
//  Created by Jae hyung Kim on 10/28/24.
//

import XCTest
@testable import AppVideoTest
import AVFoundation

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
        XCTAssertFalse(viewController.isPlaying, "Video should be paused.")
    }
    
    @MainActor
    func testSeekAfterSliderMove() {
            let expectation = self.expectation(description: "Seek End")
            
            let mockPlayer = AVPlayer(url: Bundle.main.url(forResource: "sample", withExtension: "mp4")!)
            viewController.videoPlayer = mockPlayer
            
            // 슬라이더 조작에 따른 seekTime 설정 후 완료 핸들러로 검증
            viewController.playView.slider.value = 0.5 // 절반 이동
            viewController.updateSlider() // 슬라이더 업데이트

            // 비디오 플레이어가 지정한 지점으로 이동하는지 확인
            viewController.videoPlayer?.seek(to: CMTime(seconds: 10, preferredTimescale: 600)) { _ in
                XCTAssertEqual(CMTimeGetSeconds(mockPlayer.currentTime()), 10, accuracy: 0.5)
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 2, handler: nil)
        }
}


