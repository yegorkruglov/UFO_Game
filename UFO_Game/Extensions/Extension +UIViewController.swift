//
//  Extension +UIViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit

extension UIViewController {
    
    var screenHeight: CGFloat { view.frame.height }
    var screenWidth: CGFloat { view.frame.width }
    var buttonHeight: CGFloat { screenHeight / 10 }
    var generalInset: CGFloat { 20 }
    var stackInset: CGFloat { 10 }
    var insetFromScreenEdges: CGFloat { 20 }
    var cornerRadius: CGFloat { buttonHeight / 4 }
    
    func getButton(selector: Selector, title: String? = nil, imageName: String? = nil) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = .white
        button.addTarget(nil, action: selector, for: .touchUpInside)
        if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
        }
        if let imageName = imageName {
            button.setImage(UIImage(systemName: imageName), for: .normal)
            button.tintColor = .black
        }
        
        return button
    }
}
