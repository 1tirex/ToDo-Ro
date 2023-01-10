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
    func setupData() {
        coreData.saveTask("foo", withNote: "bar", to: taskList) { Task in
            sut.currentTasks.value = [Task]
        }
    }
    
    func test_task_name() {
        XCTAssertEqual(sut.taskName, "foo")
        XCTAssertNotEqual(sut.taskName, "bar")
    }
    
    func test_number_of_current_rows() {
        //Given
        setupData()
        let sectionOne = 0
        
        //When
        let task = sut.numberOfRows(section: sectionOne)
        
        //Then
        XCTAssertTrue(task >= 1)
    }
    
    func test_title_for_section() {
        //Given
        let sectionOne = 0
        let sectionTwo = 1
        
        //When and Then
        XCTAssertEqual(sut.titleForHeader(section: sectionOne), "CURRENT TASKS")
        XCTAssertEqual(sut.titleForHeader(section: sectionTwo), "COMPLETED TASKS")
    }
    
    func test_title_for_alert() {
        //Given
        setupData()
        let index = IndexPath(row: 0, section: 0)
        let task = sut.getTask(from: index)
        
        //When and Then
        XCTAssertEqual(sut.titleForAlert(task: task), "Edit List")
        XCTAssertEqual(sut.titleForAlert(task: nil), "New List")
    }
    
    func test_title_for_done_alert() {
        //Given
        setupData()
        let index = IndexPath(row: 0, section: 0)
        
        //When
        let task = sut.titleForDoneAlert(for: index)
        
        //Then
        XCTAssertEqual(task, "Done")
    }
    
    func test_title_for_unDone_alert() {
        //Given
        setupData()
        let index = IndexPath(row: 0, section: 1)
        
        //When
        let task = sut.titleForDoneAlert(for: index)
        
        //Then
        XCTAssertEqual(task, "Undone")
    }
    
    func test_get_task_from_current_section() {
        //Given
        setupData()
        let index = IndexPath(row: 0, section: 0)
        
        //When
        let task = sut.getTask(from: index)
        
        //Then
        XCTAssertTrue(sut.currentTasks.value.count >= 1)
        XCTAssertNotNil(task)
        XCTAssertEqual(task.name, "foo")
    }
    
    func test_get_indexPath_from_taskIndex() {
        //Given
        setupData()
        
        //When
        let task = sut.taskIndex(status: false)
        
        //Then
        XCTAssertEqual(task.row, 0)
        XCTAssertEqual(task.section, 0)
    }
    
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
