//
//  ViewController.swift
//  PlaneGame
//
//  Created by Egor Kruglov on 08.09.2023.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    lazy var planeView = {
        let plane = PlaneView()
        plane.backgroundColor = .blue
        
        return plane
    }()
    lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.backgroundColor = .black
        
        return stack
    }()
    lazy var leftButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal)
        button.addTarget(self, action: #selector(moveLeft), for: .touchUpInside)
        
        return button
    }()
    lazy var rightButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal)
        button.addTarget(self, action: #selector(moveRight), for: .touchUpInside)
        
        return button
    }()
    lazy var fireButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.setTitle("FIRE", for: .normal)
        button.addTarget(self, action: #selector(fire), for: .touchUpInside)
        
        return button
    }()
    
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
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        planeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).inset(-20)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }
    
    private func startEnemiesSpawn() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(generateEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func generateEnemy() {
        let enemyView = EnemyView(
            frame: CGRect(x: 0,
                          y: -100,
                          width: 100,
                          height: 100)
        )
        enemyView.center.x = Double.random(in: minX...maxX)
        enemyView.backgroundColor = .red
        
        DispatchQueue.main.async { [unowned self] in
            self.view.insertSubview(enemyView, belowSubview: stackView)
            UIView.animate(
                withDuration: 3,
                delay: 0,
                options: .curveLinear,
                animations: { enemyView.frame.origin.y += 1000 }) { [unowned self] _ in
                    if !isGameFailed {
                        enemyView.removeFromSuperview()
                    }
                }
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
        var enemies: [EnemyView] = []
        var bullets: [BulletView] = []
        
        view.subviews.forEach { subview in
            if subview is EnemyView {
                enemies.append(subview as! EnemyView)
            } else if subview is BulletView {
                bullets.append(subview as! BulletView)
            }
        }
        
        if enemies.count != 0 {
            enemies.forEach { enemy in
                guard let enemyFrame = enemy.layer.presentation()?.frame else { return }
                
                if planeFrame.intersects(enemyFrame) {
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
                    
                    if enemyFrame.intersects(bulletFrame) {
                        print("enemy terminated")
                        enemy.removeFromSuperview()
                        bullet.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc private func fire() {
        let bullet = BulletView(
            frame: .init(origin: planeView.center,
                         size: CGSize(width: 20, height: 20))
        )
        bullet.center = planeView.center
        bullet.backgroundColor = .black
        
        DispatchQueue.main.async { [unowned self] in
            view.insertSubview(bullet, belowSubview: planeView)
            UIView.animate(
                withDuration: 3,
                delay: 0,
                options: .curveLinear,
                animations: { bullet.frame.origin.y -= 1000 }) { [unowned self] _ in
                    if !isGameFailed {
                        bullet.removeFromSuperview()
                    }
                }
        }
    }
    
    @objc private func moveLeft() {
        if planeView.center.x > 20 {
            planeView.center.x -= 50
        }
    }
    
    @objc private func moveRight() {
        if view.frame.maxX - planeView.center.x > 20 {
            planeView.center.x += 50
        }
    }
}
