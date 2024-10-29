//
//  DefaultViewController.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/28/24.
//

import UIKit
import AVKit
import AVFoundation

final class DefaultViewController: UIViewController {
    
    private lazy var photoManager = PhotoManager(presentationViewController: self)
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setUI()
        action()
        setPhotoAction()
    }
    
}

extension DefaultViewController {
    
    private func setConstraints() {
        self.view.addSubview(button)
    }
    
    private func setUI() {
        setViewUI()
        buttonUI()
    }
    
    private func setViewUI() {
        view.backgroundColor = .white
    }
    
    private func buttonUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("동영상 가져오기", for: .normal)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
    }
    
    private func action() {
        button.addAction(
            UIAction {[weak self] _ in
                guard let self else { return }
                photoManager.presentPHPickerViewController(max: 1, option: .videos)
            }
            , for: .touchUpInside)
    }
    
    private func setPhotoAction() {
        photoManager.results = {[weak self] result in
            guard let self else { return }
            
            if let url = result.first {
                if checkedURL(url: url) {
                    setVideoURL(url: url)
                }
            }
            print("뷰컨에서 받은 액션",result)
            
        }
    }
    private func checkedURL(url: URL) -> Bool {
        if FileManager.default.fileExists(atPath: url.path) {
            print("File exists at URL: \(url)")
            return true
        } else {
            print("File does not exist at URL: \(url)")
            return false
        }

    }
    private func setVideoURL(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }

            // 비디오 재생이 완료되면 임시 파일 삭제
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


