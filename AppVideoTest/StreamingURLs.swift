//
//  StreamingURLs.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 11/18/24.
//

import Foundation

enum StreamingURLs {
    static let urls: [String] = [
        "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8",
    ]
    
    static func getRandomURLString() -> String {
        return urls.randomElement()!
    }
}
