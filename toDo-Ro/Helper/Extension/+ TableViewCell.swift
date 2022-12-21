//
//  + UITableViewCell.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskLists) {
        
        let currentTasks = StorageManager.shared.tasks(list: taskList).filter { $0.isComplete == false}
        var content = defaultContentConfiguration()
        
        content.text = taskList.name
        
        if taskList.tasks?.count == 0 {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTasks.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = currentTasks.count.formatted()
            accessoryType = .none
        }

        contentConfiguration = content
    }
}
