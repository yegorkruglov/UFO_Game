//
//  GameObject.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 19.09.2023.
//

import UIKit

class GameObject: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: self.imageName)
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    let objectType: GameObjectType
    private let imageName: String
    
    init(frame: CGRect, objectType: GameObjectType, imageName: String) {
        self.objectType = objectType
        self.imageName = imageName
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(2)
            make.center.equalToSuperview()
        }
    }
    
    deinit {
        print("\(objectType.rawValue) was released")
    }
}

enum GameObjectType: String {
    case player = "Player"
    case enemy = "Enemy"
    case bullet = "Bullet"
    case backGroundItem = "BackGroundItem"
}
