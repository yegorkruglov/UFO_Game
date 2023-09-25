//
//  DataStore.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 22.09.2023.
//

import Foundation

final class DataStore {
    
    static let shared = DataStore()
    
    private let keyForGameSettings = "userSetting"
    private let keyForGameResults = "gameResults"
    
    private let userDefaults = UserDefaults()
    
    private init() {}
    
    func saveSettings(_ userSettings: GameSettings) {
        let data = try? JSONEncoder().encode(userSettings)
        userDefaults.set(data, forKey: keyForGameSettings)
    }
    
    func readSettings() -> GameSettings? {
        guard let data = userDefaults.value(forKey: keyForGameSettings) as? Data else { return nil }
        guard let userSettings = try? JSONDecoder().decode(GameSettings.self, from: data) else { return nil }
        return userSettings
    }
    
    func saveGameResults(_ gameResults: GameResults) {
        var savedResults = loadGameResults()
        savedResults.append(gameResults)
        var newResults = savedResults.sorted { $0.score > $1.score }
        if newResults.count > 10 {
            newResults.removeLast()
        }
        
        let data = try? JSONEncoder().encode(newResults)
        userDefaults.set(data, forKey: keyForGameResults)
    }
    
    func loadGameResults() -> [GameResults] {
        guard let data = userDefaults.value(forKey: keyForGameResults) as? Data else { return [] }
        guard let savedResults = try? JSONDecoder().decode([GameResults].self, from: data) else { return []}
        
        return savedResults
    }
}
