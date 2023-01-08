//
//  + UITableViewCell.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskLists = TaskLists(), task: Task? = nil) {
        var content = defaultContentConfiguration()
        
        if let task = task {
            content.text = task.name
            content.secondaryText = task.note
        } else {
            let currentTasks = StorageManager.shared
                .fetchTasks(list: taskList)
                .filter { $0.isComplete == false}
            
            content.text = taskList.name
            
            if taskList.tasks?.count == 0 {
                accessoryType = .none
            } else if currentTasks.isEmpty {
                accessoryType = .checkmark
            } else {
                accessoryType = .none
            }
            content.secondaryText = """
            \(currentTasks.count) current tasks.
            Create list at \(taskList.date.formatted(date: .abbreviated, time: .shortened) )
            """
        }
        contentConfiguration = content
    }
}
