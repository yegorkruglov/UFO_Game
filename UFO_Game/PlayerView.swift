//
//  PlaneView.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 18.09.2023.
//

import UIKit

class PlayerView: UIView {
    
    lazy var imageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fighter")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    deinit {
        print("player was released")
    }
}
