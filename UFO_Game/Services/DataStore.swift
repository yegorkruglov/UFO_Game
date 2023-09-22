//
//  DataStore.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 22.09.2023.
//

import Foundation

class DataStore {
    
    static let shared = DataStore()
    
    private let key = "userSetting"
    
    private let userDefaults = UserDefaults()
    
    private init() {}
    
    func saveSettings(_ userSettings: SelectedUserSettings) {
        let data = try? JSONEncoder().encode(userSettings)
        userDefaults.set(data, forKey: key)
    }
    
    func readUserSettings() -> SelectedUserSettings? {
        guard let data = userDefaults.value(forKey: key) as? Data else { return nil }
        let userSettings = try? JSONDecoder().decode(SelectedUserSettings.self, from: data)
        return userSettings
    }
    
}
