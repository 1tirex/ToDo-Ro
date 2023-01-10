//
//  TaskTests.swift
//  toDo-RoTests
//
//  Created by Дмитрий Собин on 29.12.22.
//

import XCTest
@testable import toDo_Ro

final class TaskTests: XCTestCase {
    
    var coreData: StorageManager!
    var taskList: TaskLists!
    
    override func setUp() {
        super.setUp()
        coreData = StorageManager(modelName: "toDo_Ro", .inMemory)
        coreData.saveTaskList(name: "foo") { TaskLists in
            taskList = TaskLists
        }
    }
    
    override func tearDown() {
        coreData = nil
        taskList = nil
        super.tearDown()
    }
}
extension TaskTests {
    func testSaveNewTask() {
        //Given
        var task = Task()
        
        //When
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            task = Task
        }
        
        //Then
        XCTAssertEqual(taskList.tasks?.count, 1)
        XCTAssertEqual(task.name, "foo")
        XCTAssertEqual(task.note, "bar")
        XCTAssertNotNil(task.date)
    }
    
    func testCreateAndFetchTask() {
        //Given
        var task: [Task] = []
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            XCTAssertNotNil(Task)
        }
        
        //When
        task = coreData.fetchTasks(list: taskList)
        
        //Then
        XCTAssertEqual(taskList.tasks?.count, 1)
        XCTAssertEqual(task.first?.name, "foo")
        XCTAssertEqual(task.first?.note, "bar")
        XCTAssertNotNil(task.first?.date)
    }
    
    func testEditTask() {
        //Given
        var task = Task()
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            task = Task
        }
        
        //When
        coreData.editTask(task, to: "baz", withNote: "foo")
        
        //Then
        XCTAssertEqual(taskList.tasks?.count, 1)
        XCTAssertEqual(task.name, "baz")
        XCTAssertEqual(task.note, "foo")
        XCTAssertNotNil(task.date)
    }
    
    func testToggleStatusTask() {
        //Given
        var task = Task()
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            task = Task
        }
        XCTAssert(task.isComplete == false)
        
        //When
        coreData.doneTask(task)
        
        //Then
        XCTAssert(task.isComplete == true)
        XCTAssertEqual(taskList.tasks?.count, 1)
        XCTAssertEqual(task.name, "foo")
        XCTAssertEqual(task.note, "bar")
        XCTAssertNotNil(task.date)
    }
    
    func testDeleteTask() {
        //Given
        var task = Task()
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            task = Task
        }
        XCTAssert(!coreData.fetchTasks(list: taskList).isEmpty)
        
        //When
        coreData.deleteTask(task)
        
        //Then
        XCTAssertEqual(taskList.tasks?.count, 0)
        XCTAssert(coreData.fetchTasks(list: taskList).isEmpty)
    }
}
