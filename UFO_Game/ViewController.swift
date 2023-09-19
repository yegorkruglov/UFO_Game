//
//  ViewController.swift
//  PlaneGame
//
//  Created by Egor Kruglov on 08.09.2023.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    var selectedPlayer: Icons.Player!
    var selectedBullet: Icons.Bullet!
    var selectedEnemy: Icons.Enemy!
    var difficulty: Difficulty!
    
    private lazy var planeView = {
        let plane = GameObject(
            frame: .zero,
            objectType: .player,
            imageName: selectedPlayer.rawValue
        )
        
        return plane
    }()
    private lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        return stack
    }()
    private lazy var leftButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moveLeft), for: .touchUpInside)
        
        return button
    }()
    private lazy var rightButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moveRight), for: .touchUpInside)
        
        return button
    }()
    private lazy var fireButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.setTitle("FIRE", for: .normal)
        button.addTarget(self, action: #selector(fire), for: .touchUpInside)
        button.layer.cornerRadius = 20
        
        return button
    }()
    
    private var screenHeight: CGFloat { view.frame.height }
    private var screenWidth: CGFloat { view.frame.width }
    private var buttonHeight: CGFloat { screenHeight / 10 }
    private var objectHeight: CGFloat { screenWidth / 6 }
    private var bulletHeight: CGFloat { screenWidth / 15 }
    private var objectRunDistance: CGFloat { screenHeight + objectHeight * 2 }
    private var moveStep: CGFloat { screenWidth / 10 }
    private var generalInset: CGFloat = 20
    private var minX: CGFloat { view.frame.width / 8 }
    private var maxX: CGFloat { view.frame.width - minX }
    
    private var timer: Timer?
    private var displayLink: CADisplayLink?
    private var isGameFailed = false
    
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
    
    deinit {
        print("GameVC was realesed")
    }
    
    private func startCollisionTracking() {
        displayLink = CADisplayLink(target: self, selector: #selector(checkForCollisions))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(fireButton)
        stackView.addArrangedSubview(rightButton)
        view.addSubview(planeView)
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(generalInset)
            make.leading.equalToSuperview().inset(generalInset)
            make.trailing.equalToSuperview().inset(generalInset)
            make.height.equalTo(buttonHeight)
        }
        
        planeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).inset(-generalInset)
            make.height.equalTo(objectHeight)
            make.width.equalTo(objectHeight)
        }
    }
    
    private func startEnemiesSpawn() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0 / difficulty.rawValue,
            target: self,
            selector: #selector(generateEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func generateEnemy() {
        let enemyView = GameObject(
            frame: CGRect(
                x: 0,
                y: -objectHeight,
                width: objectHeight,
                height: objectHeight),
            objectType: .enemy,
            imageName: selectedEnemy.rawValue
        )
        
        enemyView.center.x = Double.random(in: minX...maxX)
        
        DispatchQueue.main.async { [unowned self] in
            self.view.insertSubview(enemyView, belowSubview: stackView)
            UIView.animate(
                withDuration: 4 / difficulty.rawValue,
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
    
    private func stopGame() {
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
    
    @objc private func checkForCollisions() {
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
                
                if objectFramesDidIntersected(planeFrame, and: enemyFrame) {
                    stopGame()
                    print("game over")
                }
            }
        }
        
        if bullets.count != 0 {
            bullets.forEach { bullet in
                guard let bulletFrame = bullet.layer.presentation()?.frame else { return }
                
                enemies.forEach { enemy in
                    guard let enemyFrame = enemy.layer.presentation()?.frame else { return }
                    
                    if objectFramesDidIntersected(enemyFrame, and: bulletFrame) {
                        print("enemy terminated")
                        enemy.removeFromSuperview()
                        bullet.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    private func objectFramesDidIntersected(_ firstObjectFrame: CGRect, and secondObjectFrame: CGRect) -> Bool {
        firstObjectFrame.intersects(secondObjectFrame)
            && (firstObjectFrame.midY - secondObjectFrame.midY) < (objectHeight / 3)
            && (firstObjectFrame.midX - secondObjectFrame.midX) < (objectHeight / 3)
        
    }
    
    @objc private func fire() {
        let bullet = GameObject(
            frame: .init(
                origin: planeView.center,
                size: CGSize(
                    width: bulletHeight,
                    height: bulletHeight
                )
            ),
            objectType: .bullet,
            imageName: selectedBullet.rawValue
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
    
    @objc private func moveLeft() {
        if planeView.center.x > generalInset {
            planeView.center.x -= moveStep
        }
    }
    
    @objc private func moveRight() {
        if view.frame.maxX - planeView.center.x > generalInset {
            planeView.center.x += moveStep
        }
    }
}
