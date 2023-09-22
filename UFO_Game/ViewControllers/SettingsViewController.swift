//
//  SettingsViewController.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 20.09.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var selectedPlayerName: String?
    private var selectedPlayerIcon: Icons.Player?
    private var selectedEnemyIcon: Icons.Enemy?
    private var selectedBulletIcon: Icons.Bullet?
    private var selectedDifficulty: Difficulty?
    
    private let dataStore = DataStore.shared
    
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
        label.text = "Choose fighter, enemies, weapon and difficulty level"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    private lazy var buttonStackView = {
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
        tf.returnKeyType = .done
        tf.clearsOnBeginEditing = true
        
        return tf
    }()
    private lazy var playerSelectionSegment = {
        let icons: [UIImage] = Icons.allPlayers.map {
            UIImage(named: $0)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        }
        let seg = UISegmentedControl(items: icons)
        seg.addTarget(self, action: #selector(playerMadeSelection), for: .valueChanged)
        
        return seg
    }()
    private lazy var enemySelectionSegment = {
        let icons: [UIImage] = Icons.allEnemies.map {
            UIImage(named: $0)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        }
        let seg = UISegmentedControl(items: icons)
        seg.addTarget(self, action: #selector(playerMadeSelection), for: .valueChanged)
        
        return seg
    }()
    private lazy var bulletSelectionSegment = {
        let icons: [UIImage] = Icons.allBullets.map {
            UIImage(named: $0)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        }
        let seg = UISegmentedControl(items: icons)
        seg.addTarget(self, action: #selector(playerMadeSelection), for: .valueChanged)
        
        return seg
    }()
    private lazy var difficultySelectionSegment = {
        let levels: [String] = Difficulty.allCases.map { $0.name }
        let seg = UISegmentedControl(items: levels)
        seg.backgroundColor = .white
        seg.addTarget(self, action: #selector(playerMadeSelection), for: .valueChanged)
        
        return seg
    }()
    private lazy var segmentsStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = stackInset
        
        return stack
    }()
    private lazy var segmentsBackView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        nameTextField.delegate = self
        loadSettings()
    }
    
    deinit{
        print("SettingsVC was realesed")
    }
    
    private func loadSettings() {
        guard let loadedUserSettings = dataStore.readUserSettings() else { return }
        
        guard let loadedPlayerName = loadedUserSettings.selectedPlayerName else { return }
        nameTextField.text = loadedPlayerName
        selectedPlayerName = loadedPlayerName
        
        guard let loadedPlayerIcon = loadedUserSettings.selectedPlayerIcon else { return }
        selectedPlayerIcon = loadedPlayerIcon
        guard let playerIconIndex = Icons.Player.allCases.firstIndex(of: loadedPlayerIcon) else { return }
        playerSelectionSegment.selectedSegmentIndex = playerIconIndex
        
        guard let loadedEnemyIcon = loadedUserSettings.selectedEnemyIcon else { return }
        selectedEnemyIcon = loadedEnemyIcon
        guard let enemyIconIndex = Icons.Enemy.allCases.firstIndex(of: loadedEnemyIcon) else { return }
        enemySelectionSegment.selectedSegmentIndex = enemyIconIndex
        
        guard let loadedBulletIcon = loadedUserSettings.selectedBulletIcon else { return }
        selectedBulletIcon = loadedBulletIcon
        guard let bulletIconIndex = Icons.Bullet.allCases.firstIndex(of: loadedBulletIcon) else { return }
        bulletSelectionSegment.selectedSegmentIndex = bulletIconIndex
        
        guard let loadedDifficulty = loadedUserSettings.selectedDifficulty else { return }
        selectedDifficulty = loadedDifficulty
        guard let difficultyIndex = Difficulty.allCases.firstIndex(of: loadedDifficulty) else { return }
        difficultySelectionSegment.selectedSegmentIndex = difficultyIndex
    }
    
    @objc private func saveSettings() {
        guard let selectedPlayerName,
              let selectedPlayerIcon,
              let selectedEnemyIcon,
              let selectedBulletIcon,
              let selectedDifficulty
        else { return }
        
        
        let userSettings = SelectedUserSettings(
            selectedPlayerName: selectedPlayerName,
            selectedPlayerIcon: selectedPlayerIcon,
            selectedEnemyIcon: selectedEnemyIcon,
            selectedBulletIcon: selectedBulletIcon,
            selectedDifficulty: selectedDifficulty
        )
        
        dataStore.saveSettings(userSettings)
        
        dismiss(animated: true)
    }
    
    @objc private func dismissSettings() {
        dismiss(animated: true)
    }
    
    @objc private func playerMadeSelection(_ sender: UISegmentedControl) {
        switch sender {
        case playerSelectionSegment:
            selectedPlayerIcon = Icons.Player.allCases[sender.selectedSegmentIndex]
        case enemySelectionSegment:
            selectedEnemyIcon = Icons.Enemy.allCases[sender.selectedSegmentIndex]
        case bulletSelectionSegment:
            selectedBulletIcon = Icons.Bullet.allCases[sender.selectedSegmentIndex]
        default:
            selectedDifficulty = Difficulty.allCases[sender.selectedSegmentIndex]
        }
    }
}

extension SettingsViewController {
    private func setupUI() {
        
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(dismissButton)
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(insetFromScreenEdges)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(buttonStackView)
            make.height.equalTo(buttonStackView).dividedBy(2)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(buttonStackView)
            make.top.equalTo(nameLabel.snp.bottom).offset(generalInset)
            make.height.equalTo(buttonStackView).dividedBy(2)
        }
        nameTextField.layer.cornerRadius = cornerRadius
        
        view.addSubview(iconsLabel)
        iconsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(buttonStackView)
            make.top.equalTo(nameTextField.snp.bottom).offset(generalInset)
            make.height.equalTo(buttonStackView).dividedBy(2)
        }
        
        view.addSubview(segmentsBackView)
        segmentsBackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(buttonStackView.snp.top).inset(-generalInset)
            make.top.equalTo(iconsLabel.snp.bottom).offset(generalInset)
            make.width.equalTo(buttonStackView)
        }
        view.addSubview(segmentsStackView)
        segmentsStackView.addArrangedSubview(playerSelectionSegment)
        segmentsStackView.addArrangedSubview(enemySelectionSegment)
        segmentsStackView.addArrangedSubview(bulletSelectionSegment)
        segmentsStackView.addArrangedSubview(difficultySelectionSegment)
        segmentsStackView.snp.makeConstraints { make in
            make.edges.equalTo(segmentsBackView).inset(generalInset)
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let typedPlayerName = nameTextField.text, typedPlayerName != "" else { return false}
        selectedPlayerName = typedPlayerName
        nameTextField.resignFirstResponder()
        return true
    }
}
