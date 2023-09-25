//
//  AnimatedBacground.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 25.09.2023.
//

import UIKit

class AnimatedBacground: UIView {
    
    private var debrisTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startAnimation() {
        debrisTimer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(generateDebris),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func generateDebris() {
        let debrisView = GameObject(
            frame: CGRect(
                x: 0,
                y: -widthS,
                width: widthS,
                height: widthS),
            objectType: .backGroundItem,
            imageName: Icons.allPlanets.randomElement() ?? ""
        )
        debrisView.imageView.frame = debrisView.frame
        debrisView.alpha = 0.3
        
        debrisView.center.x  = Double.random(in: 0...viewWidth)
        
        DispatchQueue.main.async { [unowned self] in
            insertSubview(debrisView, at: 0)
            UIView.animate(
                withDuration: 6,
                delay: 2,
                options: .curveLinear,
                animations: { debrisView.frame.origin.y += 1000 }) { _ in
                    debrisView.removeFromSuperview()
                }
        }
    }
    
}
