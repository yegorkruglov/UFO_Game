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
    private lazy var startButton = getButton(selector: #selector(startGame), title: "START")
    private lazy var settingsButton = getButton(selector: #selector(openSettings), title: "SETTINGS")
    private lazy var leaderboardButton = getButton(selector: #selector(openLeaderBoard), title: "LEADERBOARD")
    
    private var gameSettings: GameSettings!
    private let dataStore = DataStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSettings()
    }
}

private extension StartViewController {
    func setupUI() {
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
    
    func loadSettings() {
        guard let loadedSettings = dataStore.readSettings() else {
            gameSettings = GameSettings(
                playerName: "Unknown Player",
                playerIcon: .player1,
                enemyIcon: .enemy1,
                bulletIcon: .bullet1,
                difficulty: .easy
            )
            dataStore.saveSettings(gameSettings)
            return
        }
        
        gameSettings = loadedSettings
    }
    
    @objc func startGame() {
        let gameVC = GameViewController(gameSettings: gameSettings)
        gameVC.modalTransitionStyle = .crossDissolve
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    @objc func openSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        
        present(settingsVC, animated: true)
    }
    
    @objc func openLeaderBoard() {
        let leaderboardVC = LeaderBoardViewController()
        leaderboardVC.modalPresentationStyle = .fullScreen
        
        present(leaderboardVC, animated: true)
    }
}
