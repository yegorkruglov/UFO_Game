//
//  ViewController.swift
//  PlaneGame
//
//  Created by Egor Kruglov on 08.09.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var planeView = {
        let plane = UIView()
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
        
    private var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        view.addSubview(planeView)
        
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        planeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).inset(-20)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(generateEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func generateEnemy() {
        let minX = view.frame.width / 8
        let maxX = view.frame.width - 20
        
        let enemyView = UIView(
            frame: CGRect(x: CGFloat.random(in: minX...maxX),
                          y: -100,
                          width: 100,
                          height: 100)
        )
        enemyView.backgroundColor = .red
        DispatchQueue.main.async {
            self.view.addSubview(enemyView)
            UIView.animate(withDuration: 5, animations: { enemyView.frame.origin.y += 1000 }) { _ in
                enemyView.removeFromSuperview()

            }
        }
        
        
        
        displayLink = CADisplayLink(target: self, selector: #selector(checkForIntersection))
        displayLink?.add(to: .main, forMode: .common)

    }
    
    @objc func checkForIntersection() {
        
        guard let view1Frame = planeView.layer.presentation()?.frame else { return }
        self.view.subviews.forEach { subview in
            guard subview.backgroundColor == .red, let view2Frame = subview.layer.presentation()?.frame else { return }
            
            if view1Frame.intersects(view2Frame) {
                displayLink?.invalidate()
                displayLink = nil
                subview.layer.removeAllAnimations()
            }
        }
        
    }

    
    @objc private func moveLeft() {
        planeView.center.x -= 50
        
    }
    
    @objc private func moveRight() {
        planeView.center.x += 50
    }
}

