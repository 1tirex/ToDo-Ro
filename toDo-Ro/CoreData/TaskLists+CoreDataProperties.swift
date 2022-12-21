//
//  TaskLists+CoreDataProperties.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//
//

import Foundation
import CoreData


extension TaskLists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskLists> {
        return NSFetchRequest<TaskLists>(entityName: "TaskLists")
    }

    @NSManaged public var name: String
    @NSManaged public var date: Date?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension TaskLists {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension TaskLists : Identifiable {

}
