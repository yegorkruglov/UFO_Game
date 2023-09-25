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
    var heightM: CGFloat { screenHeight / 10 }
    var heightS: CGFloat { screenHeight / 20 }
    var heightXS: CGFloat { screenHeight / 50 }
    var generalInset: CGFloat { 20 }
    var stackInset: CGFloat { 10 }
    var insetFromScreenEdges: CGFloat { 20 }
    var cornerRadiusM: CGFloat { heightM / 4 }
    var cornerRadiusS: CGFloat { heightS / 4 }
    var gameFont: UIFont { UIFont.systemFont(ofSize: heightXS, weight: .bold) }
    
    func getButton(selector: Selector, title: String? = nil, imageName: String? = nil) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = cornerRadiusM
        button.titleLabel?.font = gameFont
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
