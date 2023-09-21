//
//  IconCollectionViewCell.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 21.09.2023.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    static var identifier : String {
        return String(describing: self)
    }

    private let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
