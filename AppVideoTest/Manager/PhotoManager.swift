//
//  PhotoManager.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/29/24.
//

import PhotosUI

/// 갤러리 매니저
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
            
            if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                handleItemProvider(provider, typeIdentifier: UTType.movie.identifier) { url in
                    if let url = url {
                        urls.append(url)
                    }
                    group.leave()
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                handleItemProvider(provider, typeIdentifier: UTType.image.identifier) { url in
                    if let url = url {
                        urls.append(url)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) { [weak self] in
                guard let self else { return }
                results?(urls)
            }
        }
    }
    
    private func handleItemProvider(_ itemProvider: NSItemProvider, typeIdentifier: String, completion: @escaping (URL?) -> Void){
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            var resultUrl: URL? = nil
            guard let url = url, error == nil else {
                resultUrl = nil
                return
            }
        
            let destinationURL = FileManager.default
                .temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(url.pathExtension)
    
            try? FileManager.default.copyItem(at: url, to: destinationURL)
            
            resultUrl = destinationURL
            
            completion(resultUrl)
        }
    }
}
