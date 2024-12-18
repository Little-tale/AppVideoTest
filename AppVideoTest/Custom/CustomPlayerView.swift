//
//  CustomPlayerView.swift
//  AppVideoTest
//
//  Created by Jae hyung Kim on 10/31/24.
//

import UIKit

final class CustomPlayerView: UIView, BaseViewProtocol {
    private let stackView = UIStackView()
    let playView = UIView()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let playButton = UIButton()
    let exitButton = UIButton()
    let slider = UISlider()
    let getButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        designView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        [leftButton, playButton ,rightButton].forEach { stackView.addArrangedSubview($0) }
        [playView, stackView, exitButton, slider, getButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = .zero
            $0.layer.shadowRadius = 6
        }
    }
    
    func configureLayout(){
        settingStackView
        
        // MARK: playView
        NSLayoutConstraint.activate([
            playView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playView.widthAnchor.constraint(equalTo: self.widthAnchor),
            playView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        // MARK: StackView
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // MARK: Exit Button
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            exitButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            exitButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // MARK: slider
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            slider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        // MARK: getButton
        NSLayoutConstraint.activate([
            getButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            getButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            getButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func designView() {
        self.backgroundColor = .black.withAlphaComponent(0.01)
        leftButton.setTitle("left", for: .normal)
        playButton.setTitle("play", for: .normal)
        rightButton.setTitle("right", for: .normal)
        exitButton.setTitle("exit", for: .normal)
        getButton.setTitle("get", for: .normal)
    }
    
}
extension CustomPlayerView {
    private var settingStackView: Void {
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    func hidden(bool: Bool) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            [stackView, exitButton, slider, getButton].forEach { $0.isHidden = bool }
        }
    }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
    CustomViewController()
}
#endif
