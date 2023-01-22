//
//  TaskListsCellViewModel.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 16.01.23.
//

import Foundation

protocol TaskListsCellProtocol {
    var name: String { get }
    var date: String { get }
    var roundData: (Double, Int) { get }
    init(list: TaskLists)
}

final class TaskListsCellViewModel: TaskListsCellProtocol {
    var name: String {
        taskLists.name
    }
    
    var date: String {
        "Create list at \(taskLists.date.formatted(date: .abbreviated, time: .shortened))"
    }
    
    
    var roundData: (Double, Int) {
        
        
        if taskLists.tasks?.count == 0 {
            return (100, 0)
        } else if taskLists.tasks?.count == currentTasks.count {
            return (0 , countTask)
        } else {
            return (percent, countTask)
        }
    }
    
    private var percent: Double {
        currentTasks.count == 0
        ? Double(10)
        : Double(currentTasks.count) / Double(taskLists.tasks?.count ?? 1) 
    }
    
    private var countTask: Int {
        currentTasks.count
    }
    
    private let taskLists: TaskLists
    private var currentTasks: [Task] { StorageManager.shared
            .fetchTasks(list: taskLists)
            .filter { $0.isComplete == false}
    }
    
    init(list: TaskLists) {
        taskLists = list
    }
}
