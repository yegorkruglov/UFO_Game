//
//  SettingsViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var userName: String?
    private var selectedPlayerIcon: Icons.Player?
    private var selectedEnemyIcon: Icons.Enemy?
    private var selectedBulletIcon: Icons.Bullet?
    
    private lazy var nameLabel = {
        let label = UILabel()
        label.text = "Enter your name"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var iconsLabel = {
        let label = UILabel()
        label.text = "Choose fighter, enemies, missiles"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var stackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        return stack
    }()
    private lazy var saveButton = getGameButton(selector: #selector(saveSettings), title: "SAVE")
    private lazy var dismissButton = getGameButton(selector: #selector(dismissSettings), title: "CANCEL")
    
    private lazy var nameTextField = {
        let tf = UITextField()
        tf.placeholder = "Player"
        tf.backgroundColor = .white
        tf.textAlignment = .center
        
        return tf
    }()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit{
        print("SettingsVC was realesed")
    }
    @objc private func saveSettings() {
        
    }
    
    @objc private func dismissSettings() {
        dismiss(animated: true)
    }
}

extension SettingsViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(dismissButton)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(collectionView)
            make.top.equalTo(collectionView.snp.bottom).inset(-20)
            make.height.equalTo(view.frame.height / 10)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalTo(collectionView)
            make.width.equalTo(collectionView)
            make.bottom.equalTo(collectionView.snp.top).inset(-20)
            make.height.equalToSuperview().dividedBy(16)
        }
        nameTextField.layer.cornerRadius = 20
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(collectionView)
            make.width.equalTo(collectionView)
            make.bottom.equalTo(nameTextField.snp.top).inset(-20)
            make.height.equalToSuperview().dividedBy(16)
        }
    }
}
