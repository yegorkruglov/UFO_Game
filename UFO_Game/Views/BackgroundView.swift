//
//  BackgroundView.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 25.09.2023.
//

import UIKit

final class BackgroundView: UIView {

    private let planetOne = UIImageView(image: UIImage(named: "planet3"))
    private let planetTwo = UIImageView(image: UIImage(named: "planet2"))
    private let planetThree = UIImageView(image: UIImage(named: "planet1"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(planetOne)
        planetOne.snp.makeConstraints { make in
            make.height.width.equalTo(widthS)
            make.centerX.equalTo(viewWidth / 4)
            make.centerY.equalTo(viewHeight / 6)
        }
        
        addSubview(planetTwo)
        planetTwo.snp.makeConstraints { make in
            make.centerY.equalTo(viewHeight * 0.4)
            make.centerX.equalTo(viewWidth)
            make.height.width.equalTo(widthM)
        }
        
        addSubview(planetThree)
        planetThree.snp.makeConstraints { make in
            make.centerY.equalTo(viewHeight * 0.8)
            make.centerX.equalTo(viewWidth / 4)
            make.height.width.equalTo(widthL)
        }
    }
}
