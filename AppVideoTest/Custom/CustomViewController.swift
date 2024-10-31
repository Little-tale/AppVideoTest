//
//  CustomViewController.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/31/24.
//

import UIKit

final class CustomViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        view = CustomPlayerView()
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    CustomViewController()
}
#endif
