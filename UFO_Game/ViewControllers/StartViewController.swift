//
//  StartViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    
    private lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        
        return stack
    }()
    private lazy var startButton = getGameButton(selector: #selector(startGame), title: "START")
    private lazy var settingsButton = getGameButton(selector: #selector(startGame), title: "SETTINGS")
    private lazy var leaderboardButton = getGameButton(selector: #selector(startGame), title: "LEADERBOARD")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc private func startGame() {
        
    }
    
}

extension StartViewController {
    private func setupUI() {
        view.backgroundColor = .black
        
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(leaderboardButton)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        
    }
}
