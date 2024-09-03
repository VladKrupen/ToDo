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
    private let key: String = "Network"
    
    func areTasksLoadedFromNetwork() -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func updateTasksLoadedStatus() {
        userDefaults.set(true, forKey: key)
    }
}
