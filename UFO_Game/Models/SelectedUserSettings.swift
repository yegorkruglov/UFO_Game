//
//  SelectedUserSettings.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 22.09.2023.
//

import Foundation

class SelectedUserSettings: Codable {
    
    var selectedPlayerName: String?
    var selectedPlayerIcon: Icons.Player?
    var selectedEnemyIcon: Icons.Enemy?
    var selectedBulletIcon: Icons.Bullet?
    var selectedDifficulty: Difficulty?
    
    init(selectedPlayerName: String? = nil, selectedPlayerIcon: Icons.Player? = nil, selectedEnemyIcon: Icons.Enemy? = nil, selectedBulletIcon: Icons.Bullet? = nil, selectedDifficulty: Difficulty? = nil) {
        self.selectedPlayerName = selectedPlayerName
        self.selectedPlayerIcon = selectedPlayerIcon
        self.selectedEnemyIcon = selectedEnemyIcon
        self.selectedBulletIcon = selectedBulletIcon
        self.selectedDifficulty = selectedDifficulty
    }
}
