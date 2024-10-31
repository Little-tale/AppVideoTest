//
//  BaseViewProtocol.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/31/24.
//

import Foundation

protocol BaseViewProtocol {
    /// 뷰계층
    func configureHierarchy()
    /// 레이아웃
    func configureLayout()
    /// 디자인
    func designView()
    /// 레지스터
    func register()
}

extension BaseViewProtocol {
    func register() {
        
    }
}
