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
            return (100, 1)
        } else {
            return (percent, countTask)
        }
    }
    
    private var percent: Double {
        Double(currentTasks.count == 0
               ? taskLists.tasks?.count ?? 1
               : currentTasks.count) / Double(taskLists.tasks?.count ?? 1) * 10
    }
    
    private var countTask: Int {
        currentTasks.count
    }
    
    private let taskLists: TaskLists
    private let currentTasks: [Task]
    
    init(list: TaskLists) {
        taskLists = list
        currentTasks = StorageManager.shared
            .fetchTasks(list: list)
            .filter { $0.isComplete == false}
    }
}
