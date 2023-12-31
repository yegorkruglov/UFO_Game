//
//  ViewController.swift
//  PlaneGame
//
//  Created by Egor Kruglov on 08.09.2023.
//

import UIKit

final class GameViewController: UIViewController {
        
    private lazy var planeView = {
        let plane = GameObject(
            frame: .zero,
            objectType: .player,
            imageName: gameSettings.playerIcon.rawValue
        )
        
        return plane
    }()
    private lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = stackInset
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        return stack
    }()
    private lazy var leftButton = getButton(selector: #selector(moveLeft), imageName: "arrowshape.left.fill")
    private lazy var rightButton = getButton(selector: #selector(moveRight), imageName: "arrowshape.right.fill")
    private lazy var fireButton = getButton(selector: #selector(fire), title: "FIRE")
    private lazy var scoreLabel = {
        let label = UILabel()
        label.text = String(score)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: heightS, weight: .bold)
        
        return label
    }()
    private lazy var closeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.addTarget(nil, action: #selector(closeGame), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        return button
    }()
    private lazy var background = {
        let back = BackgroundView(frame: self.view.frame)
        back.alpha = 0.6
        
        return back
    }()
    private var gameOverAlert: UIAlertController {
        let alert = UIAlertController(
            title: "Game Over!",
            message: "\(gameSettings.playerName), you score - \(score).",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Exit",
                style: .default,
                handler: { [unowned self] _ in
                    self.exitGame()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Try again",
                style: .default,
                handler: { [unowned self] _ in
                    self.restartGame()
                }
            )
        )
        
        return alert
    }
    
    private var timer: Timer?
    private var displayLink: CADisplayLink?
    private var isGameFailed = false
    private var score = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    private let dataStore = DataStore.shared
    private let gameSettings: GameSettings
    private lazy var playerName = { gameSettings.playerName }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        planeView.translatesAutoresizingMaskIntoConstraints = true
        startEnemiesSpawn()
        startCollisionTracking()
    }
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("GameVC was realesed")
    }
}

private extension GameViewController {
    var objectHeight: CGFloat { screenWidth / 10 }
    var bulletHeight: CGFloat { screenWidth / 30 }
    var objectRunDistance: CGFloat { screenHeight + objectHeight * 2 }
    var moveStep: CGFloat { screenWidth / 10 }
    var minX: CGFloat { view.frame.width / 8 }
    var maxX: CGFloat { view.frame.width - minX }
    
    func startCollisionTracking() {
        displayLink = CADisplayLink(target: self, selector: #selector(checkForCollisions))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        view.insertSubview(background, at: 0)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(fireButton)
        stackView.addArrangedSubview(rightButton)
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(insetFromScreenEdges)
            make.leading.equalToSuperview().inset(insetFromScreenEdges)
            make.trailing.equalToSuperview().inset(insetFromScreenEdges)
            make.height.equalTo(heightM)
        }
        
        view.addSubview(planeView)
        planeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).inset(-generalInset * 2)
            make.height.equalTo(objectHeight)
            make.width.equalTo(objectHeight)
        }
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.height.width.equalTo(heightM)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(insetFromScreenEdges)
            scoreLabel.layer.cornerRadius = cornerRadiusS
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(heightS)
            make.centerY.equalTo(scoreLabel)
            make.leading.equalToSuperview().offset(insetFromScreenEdges)
        }
        
    }
    
    func startEnemiesSpawn() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0 / gameSettings.difficulty.rawValue,
            target: self,
            selector: #selector(generateEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func generateEnemy() {
        let enemyView = GameObject(
            frame: CGRect(
                x: 0,
                y: -objectHeight,
                width: objectHeight,
                height: objectHeight),
            objectType: .enemy,
            imageName: gameSettings.enemyIcon.rawValue
        )
        
        enemyView.center.x = Double.random(in: minX...maxX)
        
        DispatchQueue.main.async { [unowned self] in
            self.view.insertSubview(enemyView, belowSubview: stackView)
            UIView.animate(
                withDuration: 4 / gameSettings.difficulty.rawValue,
                delay: 0,
                options: .curveLinear,
                animations: { [unowned self] in
                    enemyView.frame.origin.y += objectRunDistance
                },
                completion: { [unowned self] _ in
                    if !isGameFailed {
                        enemyView.removeFromSuperview()
                    }
                }
            )
        }
    }
    
    func stopGame() {
        isGameFailed = true
        displayLink?.invalidate()
        displayLink = nil
        timer?.invalidate()
        timer = nil
        UIView.setAnimationsEnabled(false)
        view.subviews.forEach { subview in
            if let presentationLayer = subview.layer.presentation() {
                subview.frame = presentationLayer.frame
            }
            subview.layer.removeAllAnimations()
        }
    }
    
    @objc func checkForCollisions() {
        guard let planeFrame = planeView.layer.presentation()?.frame else { return }
        var enemies: [GameObject] = []
        var bullets: [GameObject] = []
        
        view.subviews.forEach { subview in
            guard let subview = subview as? GameObject else { return }
            if subview.objectType == .enemy {
                enemies.append(subview)
            } else if subview.objectType == .bullet {
                bullets.append(subview)
            }
        }
        
        if enemies.count != 0 {
            enemies.forEach { enemy in
                guard let enemyFrame = enemy.layer.presentation()?.frame else { return }
                
                if objectsFramesDidIntersected(planeFrame, and: enemyFrame) {
                    stopGame()
                    print("game over")
                    saveGameResults()
                    present(gameOverAlert, animated: true)
                }
            }
        }
        
        if bullets.count != 0 {
            bullets.forEach { bullet in
                guard let bulletFrame = bullet.layer.presentation()?.frame else { return }
                
                enemies.forEach { enemy in
                    guard let enemyFrame = enemy.layer.presentation()?.frame else { return }
                    
                    if objectsFramesDidIntersected(enemyFrame, and: bulletFrame) {
                        print("enemy terminated")
                        score += 1
                        enemy.removeFromSuperview()
                        bullet.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func objectsFramesDidIntersected(_ firstObjectFrame: CGRect, and secondObjectFrame: CGRect) -> Bool {
        firstObjectFrame.intersects(secondObjectFrame)
    }
    
    @objc func fire() {
        if !isGameFailed {
            let bullet = GameObject(
                frame: .init(
                    origin: planeView.center,
                    size: CGSize(
                        width: bulletHeight,
                        height: bulletHeight
                    )
                ),
                objectType: .bullet,
                imageName: gameSettings.bulletIcon.rawValue
            )
            
            bullet.center = planeView.center
            
            DispatchQueue.main.async { [unowned self] in
                view.insertSubview(bullet, belowSubview: planeView)
                UIView.animate(
                    withDuration: 3,
                    delay: 0,
                    options: .curveLinear,
                    animations: { [unowned self] in
                        bullet.frame.origin.y -= objectRunDistance
                    },
                    completion: { [unowned self] _ in
                        if !isGameFailed {
                            bullet.removeFromSuperview()
                        }
                    }
                )
            }
        }
    }
    
    @objc func moveLeft() {
        if planeView.center.x > generalInset && !isGameFailed{
            planeView.center.x -= moveStep
        }
    }
    
    @objc func moveRight() {
        if view.frame.maxX - planeView.center.x > generalInset && !isGameFailed {
            planeView.center.x += moveStep
        }
    }
    
    func saveGameResults() {
        let gameResults = GameResults(playerName: playerName, score: score)
        dataStore.saveGameResults(gameResults)
    }
    
    @objc func exitGame() {
        UIView.setAnimationsEnabled(true)
        dismiss(animated: true)
    }
    
    @objc func closeGame() {
        stopGame()
        saveGameResults()
        present(gameOverAlert, animated: true)
    }
    
    @objc func restartGame() {
        stopGame()
        removeBulletsAndEnemies()
        saveGameResults()
        
        isGameFailed = false
        
        planeView.center.x = stackView.center.x
        UIView.setAnimationsEnabled(true)
        score = 0
        startEnemiesSpawn()
        startCollisionTracking()
    }
    
    func removeBulletsAndEnemies() {
        view.subviews.forEach { subview in
            guard let subview = subview as? GameObject else { return }
            if subview.objectType != .player {
                subview.removeFromSuperview()
            }
        }
    }
}
