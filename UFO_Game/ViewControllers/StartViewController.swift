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
        stack.spacing = stackInset
        
        return stack
    }()
    private lazy var startButton = getGameButton(selector: #selector(startGame), title: "START")
    private lazy var settingsButton = getGameButton(selector: #selector(openSettings), title: "SETTINGS")
    private lazy var leaderboardButton = getGameButton(selector: #selector(openLeaderBoard), title: "LEADERBOARD")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc private func startGame() {
        let gameVC = GameViewController(
            selectedPlayer: .player1,
            selectedBullet: .bullet1,
            selectedEnemy: .enemy1,
            difficulty: .easy
        )
        gameVC.modalTransitionStyle = .crossDissolve
        present(gameVC, animated: true)
    }
    
    @objc private func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        settingsVC.modalTransitionStyle = .flipHorizontal
        present(settingsVC, animated: true)
    }
    
    @objc private func openLeaderBoard() {
        
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
            make.width.equalToSuperview().inset(insetFromScreenEdges)
            make.center.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
    }
}
