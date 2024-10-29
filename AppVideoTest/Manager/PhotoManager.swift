//
//  PhotoManager.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/29/24.
//

import UIKit.UIImage
import PhotosUI
import AVFoundation

enum PhotoManagerError: Error {
    case noAuth
    case fail
    
    var message: String {
        switch self {
        case .noAuth:
            "권한이 없습니다."
        case .fail:
            "실패하였습니다."
        }
    }
}

/// 이미지 관련된 기능을 제공하는 서비스 클래스 입니다.
final class PhotoManager: NSObject {
    
    /// 이미지 피커를 띄울 뷰컨을 정의해주세요
    private weak var presentationViewController: UIViewController!
    
    private var config: PHPickerConfiguration = PHPickerConfiguration()
    
    init(presentationViewController: UIViewController!) {
        self.presentationViewController = presentationViewController
    }
    
    // 편의상 클로저
    var results: (([URL]) -> Void)?

    // MARK: 갤러리
    func presentPHPickerViewController(max: Int, option: PHPickerFilter? = nil) {
        var config = PHPickerConfiguration()
        config.selectionLimit = max // 선택할수 있는 개수를 정합니다.
        config.filter = option // 유형
        self.config = config
        
        let picker = PHPickerViewController(configuration: self.config)
        picker.delegate = self
        DispatchQueue.main.async {
            [weak self] in
            guard let self,
                  let presentationViewController else {
                return
            }
            print("present")
            presentationViewController.present(picker, animated: true)
        }
    }
    
    deinit {
        print("ImageService : SUCCESS DEINIT")
    }
}

// MARK: 딜리게이트 채택
extension PhotoManager: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 선택이 감지되면 내립니다.
        picker.dismiss(animated: true)
        // 결과를 아이템 프로바이더 -> PhotosUI_PHPickerResult(구조체)_프로퍼티
        let imageProviders = providers(results: results)
        
        providerProcess(providers: imageProviders)
    }
    
    private func providers(results: [PHPickerResult]) -> [NSItemProvider] {
        return results.map { $0.itemProvider }
    }
    
    private func providerProcess(providers: [NSItemProvider]) {
        if self.config.filter == .videos {
            videoProcess(providers: providers)
        } else {
            // 다른 것도 많습니다.
            print("none")
        }
    }
    
    private func videoProcess(providers: [NSItemProvider]){
        var urls = [URL]()

        let group = DispatchGroup()
        
        providers.forEach { provider in
            group.enter()
            
            // 동영상의 UTType 식별자: "public.movie"
            if provider.hasItemConformingToTypeIdentifier("public.movie") {
                provider.loadItem(forTypeIdentifier: "public.movie", options: nil) { (item, error) in
                    defer { group.leave() }
                    
                    if let url = item as? URL {
                        print("Video URL: \(url)")
                        urls.append(url)
                    } else if let error = error {
                        print("Failed to load video URL: \(error)")
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            results?(urls)
        }
    }
}
