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
        stack.spacing = stackInset
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
    private var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
       cv.backgroundColor = .white
       cv.layer.cornerRadius = 20
       
        return cv
    }()
    
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
       
        view.addSubview(stackView)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(dismissButton)
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(insetFromScreenEdges)
            make.bottom.equalToSuperview().inset(generalInset)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(stackView)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView)
            make.top.equalTo(nameLabel.snp.bottom).offset(generalInset)
            make.height.equalToSuperview().dividedBy(16)
        }
        nameTextField.layer.cornerRadius = cornerRadius
        
        view.addSubview(iconsLabel)
        iconsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView)
            make.top.equalTo(nameTextField.snp.bottom).offset(generalInset)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView)
            make.top.equalTo(iconsLabel.snp.bottom).offset(generalInset)
            make.bottom.equalTo(stackView.snp.top).inset(-generalInset)
        }
    }
}
