//
//  DataMeneger.swift
//  toDo-Ro
//
//  Created by Илья on 20.12.2022.
//

import CoreData

enum StorageType {
  case persistent, inMemory
}

final class StorageManager {
    static let shared = StorageManager(modelName: "toDo_Ro")
    
    // MARK: - Core Data stack
//    private let persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "toDo_Ro")
//
//        container.loadPersistentStores { _, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        return container
//    }()
    
//    private let viewContext: NSManagedObjectContext
    
//    private init() {
//        viewContext = persistentContainer.viewContext
//    }
    
    private let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    
    init(modelName: String, _ storageType: StorageType = .persistent) {
        persistentContainer = {
            let container = NSPersistentContainer(name: modelName)
            
            if storageType == .inMemory {
                let description = NSPersistentStoreDescription()
                description.url = URL(fileURLWithPath: "/dev/null")
                container.persistentStoreDescriptions = [description]
            }
            
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
    }
}

extension StorageManager {
    // MARK: - Task List
    func fetchTaskLists(completion: (Result<[TaskLists], Error>) -> Void) {
        let fetchRequest = TaskLists.fetchRequest()
        
        do {
            let TaskLists = try viewContext.fetch(fetchRequest)
            completion(.success(TaskLists))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveTaskList(name: String, completion: (TaskLists) -> Void) {
        let taskList = TaskLists(context: viewContext)
        taskList.name = name
        taskList.date = .now
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
    
    func deleteTaskList(_ taskList: TaskLists) {
        viewContext.delete(taskList)
        saveContext()
    }
    
    // MARK: - Tasks
    func fetchTasks(list: TaskLists, status: Bool? = nil) -> [Task] {
        var fetchedTasks: [Task] = []
        
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let pred = NSPredicate(format: "taskList = %@", list)
            request.predicate = pred
            
            if status == nil {
                fetchedTasks = try viewContext.fetch(request)
            } else {
                fetchedTasks = try viewContext.fetch(request).filter{ $0.isComplete == status }
            }
        } catch {
            print("Error fetching songs \(error)")
        }
        return fetchedTasks
    }
    
    func saveTask(_ name: String, withNote note: String, to taskList: TaskLists, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.note = note
        task.name = name
        task.date = .now
        taskList.addToTasks(task)
        completion(task)
        saveContext()
    }
    
    func editTask(_ task: Task, to name: String, withNote note: String) {
        task.name = name
        task.note = note
        saveContext()
    }
    
    func doneTask(_ task: Task) {
        task.isComplete.toggle()
        saveContext()
    }
    
    func deleteTask(_ task: Task) {
        viewContext.delete(task)
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
