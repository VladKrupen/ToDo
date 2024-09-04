//
//  UserDefaultsManager.swift
//  ToDo
//
//  Created by Vlad on 3.09.24.
//

import Foundation

protocol TaskLoadingStatusProtocol {
    func areTasksLoadedFromNetwork() -> Bool
    func updateTasksLoadedStatus()
}

final class UserDefaultsManager: TaskLoadingStatusProtocol {
    private let userDefaults = UserDefaults.standard
    private let taskLoadedKey: String = "Network"
    
    func areTasksLoadedFromNetwork() -> Bool {
        return userDefaults.bool(forKey: taskLoadedKey)
    }
    
    func updateTasksLoadedStatus() {
        userDefaults.set(true, forKey: taskLoadedKey)
    }
}
