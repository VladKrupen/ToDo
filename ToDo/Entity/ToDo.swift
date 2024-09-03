//
//  ToDo.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import Foundation
import CoreData

struct ToDo {
    var id: String?
    var title: String?
    var description: String?
    var completed: Bool?
    var date: Date?
}

extension ToDo {
    init(task: Task) {
        self.id = task.id
        self.title = task.title
        self.description = task.taskDescription
        self.completed = task.completed
        self.date = task.date
    }
}
