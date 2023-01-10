//
//  TestTasksViewModel.swift
//  toDo-RoTests
//
//  Created by Дмитрий Собин on 10.01.23.
//

import XCTest
@testable import toDo_Ro

final class TestTasksViewModel: XCTestCase {
    
    var coreData: StorageManager!
    var taskList: TaskLists!
    var sut: TasksViewModel!
    
    override func setUp() {
        super.setUp()
        coreData = StorageManager(modelName: "toDo_Ro", .inMemory)
        coreData.saveTaskList(name: "foo") { TaskLists in
            taskList = TaskLists
        }
        sut = TasksViewModel(taskList: taskList)
    }
    
    override func tearDown() {
        coreData = nil
        taskList = nil
        sut = nil
        super.tearDown()
    }
}

extension TestTasksViewModel {
    

    
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
}
