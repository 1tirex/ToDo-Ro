//
//  Task+CoreDataProperties.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var isComplete: Bool
    @NSManaged public var note: String?
    @NSManaged public var taskList: TaskLists?

}

extension Task : Identifiable {

}
