//
//  DataMeneger.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "toDo_Ro")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Task List
    func fetchData(completion: (Result<[TaskLists], Error>) -> Void) {
        let fetchRequest = TaskLists.fetchRequest()
        
        do {
            let TaskLists = try viewContext.fetch(fetchRequest)
            completion(.success(TaskLists))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func createTaskList(name: String, completion: (TaskLists) -> Void) {
        let taskList = TaskLists(context: viewContext)
        taskList.name = name
        completion(taskList)
        saveContext()
    }
    
    func editTaskList(_ taskList: TaskLists, newValue: String) {
        taskList.name = newValue
        saveContext()
    }
    
    func doneTaskList(_ taskList: TaskLists) {
        taskList.tasks?.setValue(true, forKey: "isComplete")
        saveContext()
    }
    
    func deleteTaskList(_ taskListName: TaskLists) {
        viewContext.delete(taskListName)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
