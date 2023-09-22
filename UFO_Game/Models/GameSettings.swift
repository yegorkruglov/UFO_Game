//
//  GameSettings.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 22.09.2023.
//

import Foundation

class GameSettings: Codable {
    
    var playerName: String
    var playerIcon: Icons.Player
    var enemyIcon: Icons.Enemy
    var bulletIcon: Icons.Bullet
    var difficulty: Difficulty
    
    init(playerName: String, playerIcon: Icons.Player, enemyIcon: Icons.Enemy, bulletIcon: Icons.Bullet, difficulty: Difficulty) {
        self.playerName = playerName
        self.playerIcon = playerIcon
        self.enemyIcon = enemyIcon
        self.bulletIcon = bulletIcon
        self.difficulty = difficulty
    }
}
