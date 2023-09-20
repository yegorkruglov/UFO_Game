//
//  Extension +UIViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit

extension UIViewController {
    func getGameButton(selector: Selector, title: String? = nil, imageName: String? = nil) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.addTarget(nil, action: selector, for: .touchUpInside)
        if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
        }
        if let imageName = imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
            button.imageView?.tintColor = .black
        }
        
        return button
    }
}
