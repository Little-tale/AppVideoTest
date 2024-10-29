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
        photoManager.results = { result in
            print("뷰컨에서 받은 액션",result)
        }
    }
}


