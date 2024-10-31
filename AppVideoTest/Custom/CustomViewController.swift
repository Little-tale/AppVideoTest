//
//  CustomViewController.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/31/24.
//

import UIKit
import AVKit

final class CustomViewController: UIViewController {
    
    private let playView = CustomPlayerView()
    private var videoPlayer : AVPlayer? = nil
    private lazy var videoManager = PhotoManager(presentationViewController: self)
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentAction()
    }
    
    override func loadView() {
        view = playView
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
    }
    
    
    private func setVideo(_ url: URL) {
        videoPlayer = AVPlayer(url: url)
        guard let videoPlayer else { return }
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = view.frame
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.playView.playView.layer.addSublayer(playerLayer)
        }
        removeTempFile(player: videoPlayer, url: url)
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
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    CustomViewController()
}
#endif
