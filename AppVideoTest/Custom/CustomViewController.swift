//
//  CustomViewController.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/31/24.
//

import UIKit
import AVKit

final class CustomViewController: UIViewController {
    
     let playView = CustomPlayerView()
     var videoPlayer : AVPlayer? = nil
     lazy var videoManager = PhotoManager(presentationViewController: self)
     var isPlaying = false
     var ifPause: Bool = false
     var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentAction()
    }
    
    override func loadView() {
        view = playView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setTimer()
        playView.hidden(bool: false)
    }
}

extension CustomViewController {
    
    private func sentAction() {
        // MARK: GetButton
        playView.getButton.addAction(
            UIAction {[ weak self ] _ in
                self?.videoManager.results = { url in
                    if let url = url.first {
                        self?.setVideo(url)
                    }
                }
                self?.videoManager.presentPHPickerViewController(max: 1, option: .videos)
            }
            , for: .touchUpInside)
        
        // MARK: PlayButton
        playView.playButton.addAction(
            UIAction { [weak self] _ in
                if self?.isPlaying ?? false {
                    self?.videoPlayer?.pause()
                    self?.isPlaying = false
                } else {
                    self?.videoPlayer?.play()
                    self?.isPlaying = true
                }
            },
            for: .touchUpInside
        )
        
        // MARK: ExitButton
        playView.exitButton.addAction(
            UIAction { [weak self] _ in
                self?.removePlayer()
            },
            for: .touchUpInside
        )
        
        // MARK: slider
        playView.slider.addAction(
            UIAction { [weak self] _ in
                guard let weakSelf = self else { return }
                
                weakSelf.videoPlayer?.pause() // 슬라이더 조작 중에는 일시 정지
                weakSelf.ifPause = true
                
                guard let duration = weakSelf.videoPlayer?.currentItem?.duration else { return }
                let value = Float64(weakSelf.playView.slider.value) * CMTimeGetSeconds(duration)
                let seekTime = CMTime(seconds: value, preferredTimescale: 600)
                
                // 시크 완료 후 다시 재생
                weakSelf.videoPlayer?.seek(to: seekTime) { _ in
                    weakSelf.videoPlayer?.play()
                    weakSelf.ifPause = false
                }
            },
            for: .touchUpInside // 슬라이더 끝난 경우에만
        )
        
        playView.slider.addAction(
            UIAction { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.videoPlayer?.pause()
                weakSelf.ifPause = true
            },
            for: .touchDown // 슬라이더 시작 시 일시 정지
        )
        
        // MARK: 좌우 버튼 액션
        playView.leftButton.addAction(
            UIAction { [weak self] _ in
                self?.moveTime(to: -10)
        }, for: .touchUpInside)
        
        playView.rightButton.addAction(
            UIAction { [weak self] _ in
                self?.moveTime(to: 10)
            }, for: .touchUpInside)
        
        setTimer()
    }
    
    private func videoPlayerObserve() {
        // MARK: Slider ( NSEC_PER_SEC == 1초 -> 1,000,000,000 나노초로 )
        videoPlayer?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main,
            using: {[weak self] _ in
                guard let self else { return }
                if !ifPause {
                    print("adasdkjaks;j")
                    updateSlider()
                }
        })
        
    }
    
    private func setTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        // MARK: Timer
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.timerEvent()
        }
    }
    
    private func timerEvent() {
        playView.hidden(bool: true)
    }
    
    
    func setVideo(_ url: URL) {
        videoPlayer = AVPlayer(url: url)
        guard let videoPlayer else { return }
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = view.frame
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.removePlayer()
            self?.playView.playView.layer.addSublayer(playerLayer)
        }
        removeTempFile(player: videoPlayer, url: url)
        videoPlayerObserve()
    }
    
    private func removePlayer() {
        playView.playView.layer.sublayers?.forEach{ layer in
            if layer is AVPlayerLayer {
                videoPlayer?.pause()
                layer.removeFromSuperlayer()
                isPlaying = false
            }
        }
    }
    
    private func removeTempFile(player: AVPlayer, url: URL) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            do {
                try FileManager.default.removeItem(at: url)
                print("Temporary file deleted: \(url)")
            } catch {
                print("Failed to delete temporary file: \(error)")
            }
            
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
    
    private func updateSlider() {
        guard let currentTime = videoPlayer?.currentTime() else { return }
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        playView.slider.value = Float(currentTimeInSecond)
        
        if let currentItem = videoPlayer?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            playView.slider.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
        }
    }
    
    private func moveTime(to sec: Double) {
        guard let videoPlayer else { return }
        videoPlayer.pause()
        let currentTime = videoPlayer.currentTime()
        let moveTime = CMTimeGetSeconds(currentTime).advanced(by: sec)
        let seekTime = CMTime(value: CMTimeValue(moveTime), timescale: 1)
        
        videoPlayer.seek(to: seekTime) { _ in
            videoPlayer.play()
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    CustomViewController()
}
#endif
