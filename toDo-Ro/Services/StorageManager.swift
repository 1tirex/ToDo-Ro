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
    
    func deleteTaskList(_ taskList: TaskLists) {
        viewContext.delete(taskList)
        saveContext()
    }
    
    // MARK: - Tasks
    
    func tasks(list: TaskLists, status: Bool? = nil) -> [Task] {
        var fetchedTasks: [Task] = []
        
        do {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let pred = NSPredicate(format: "taskList = %@", list)
            request.predicate = pred
            
            if status == nil {
                fetchedTasks = try viewContext.fetch(request)
            } else {
                guard let status = status else { return []}
                print(status)
                fetchedTasks = try viewContext.fetch(request).filter{ $0.isComplete == status }
            }
        } catch {
            print("Error fetching songs \(error)")
        }
        return fetchedTasks
    }
    
    func save(_ name: String, withNote note: String, to taskList: TaskLists, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.note = note
        task.name = name
        task.isComplete = false
        taskList.addToTasks(task)
        completion(task)
        saveContext()
    }
    
    func rename(_ task: Task, to name: String, withNote note: String) {
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
    
    //
//    func fetchCount() {
//        do {
//            let request = TaskLists.fetchRequest() as NSFetchRequest<TaskLists>
//            let fetch = try viewContext.fetch(request)
//            
//        } catch {
//            print(error)
//        }
//    }
    //
    
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
