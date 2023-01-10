//
//  TaskListsTests.swift
//  toDo-RoTests
//
//  Created by Илья on 20.12.2022.
//

import XCTest
@testable import toDo_Ro

final class TaskListsTests: XCTestCase {
    
    var coreData: StorageManager!
    
    override func setUp() {
        super.setUp()
        coreData = StorageManager(modelName: "toDo_Ro", .inMemory)
    }
    
    override func tearDown() {
        coreData = nil
        super.tearDown()
    }
}

extension TaskListsTests {
    func testSaveNewTaskLists() {
        //Given
        var taskLists = TaskLists()
        
        //When
        coreData.saveTaskList(name: "foo") { TaskLists in
            XCTAssertNotNil(TaskLists)
            taskLists = TaskLists
        }
        
        //Then
        XCTAssertEqual(taskLists.name, "foo")
        XCTAssertNotNil(taskLists.date)
        XCTAssertNotNil(taskLists.tasks)
    }
    
    func testCreateAndFetchTaskLists() {
        //Given
        var taskLists: [TaskLists] = []
        
        coreData.saveTaskList(name: "foo") { TaskLists in
            XCTAssertNotNil(TaskLists)
        }
        
        //When
        coreData.fetchTaskLists { result in
            switch result {
            case .success(let TaskLists):
                XCTAssertNotNil(TaskLists)
                taskLists = TaskLists
            case .failure(let error):
                XCTAssertNil(error, "Save did not occur")
            }
        }
        
        //Then
        let firstTaskList = taskLists.first
        XCTAssertEqual(firstTaskList?.name, "foo")
        XCTAssertNotNil(firstTaskList?.date)
        XCTAssertNotNil(firstTaskList?.tasks)
    }
    
    func testEditTaskLists() {
        //Given
        var taskLists = TaskLists()
        
        coreData.saveTaskList(name: "foo") { TaskLists in
            XCTAssertNotNil(TaskLists)
            taskLists = TaskLists
        }
        
        //When
        coreData.editTaskList(taskLists, newValue: "bar")
        
        //Then
        XCTAssertEqual(taskLists.name, "bar")
        XCTAssertNotNil(taskLists.date)
        XCTAssertNotNil(taskLists.tasks)
    }
    
    func testDeleteTaskLists() {
        //Given
        var taskLists = TaskLists()
        
        coreData.saveTaskList(name: "foo") { TaskLists in
            XCTAssertNotNil(TaskLists)
            taskLists = TaskLists
        }
        
        //When
        coreData.deleteTaskList(taskLists)
        
        //Then
        coreData.fetchTaskLists { result in
            switch result {
            case .success(let TaskLists):
                XCTAssert(TaskLists.isEmpty)
            case .failure(let error):
                XCTAssertNil(error, "Save did not occur")
            }
        }
    }
    
    func testChangeStatusTasksToDoneInTaskLists() {
        //Given
        var taskLists = TaskLists()
        coreData.saveTaskList(name: "foo") { TaskLists in
            XCTAssertNotNil(TaskLists)
            taskLists = TaskLists
        }
        
        var task = Task()
        coreData.saveTask("foo", withNote: "bar", to: taskLists) { Task in
            task = Task
        }
        
        XCTAssertEqual(task.isComplete, false)
        XCTAssertEqual(taskLists.tasks?.count, 1)
        
        //When
        coreData.doneTaskList(taskLists)
        
        //Then
        XCTAssertEqual(task.isComplete, true)
        XCTAssertEqual(taskLists.tasks?.count, 1)
    }
    
    func testPerformanceExample() {
        self.measure {
            
        }
    }
}
