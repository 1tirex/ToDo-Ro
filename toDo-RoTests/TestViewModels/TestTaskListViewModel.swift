//
//  TestTaskListViewModel.swift
//  toDo-RoTests
//
//  Created by Дмитрий Собин on 10.01.23.
//

import XCTest
@testable import toDo_Ro

final class TestTaskListViewModel: XCTestCase {
    
    var sut: TaskListViewModel!
    var coreData: StorageManager!
    
    override func setUp() {
        super.setUp()
        sut = TaskListViewModel()
        coreData = StorageManager(modelName: "toDo_Ro", .inMemory)
    }
    
    override func tearDown() {
        sut = nil
        coreData = nil
        super.tearDown()
    }
}

extension TestTaskListViewModel {
    
    private func test_Fetch_TaskList() {
        //Given
        XCTAssertEqual(sut.numberOfSection, 0)
        
        //When
        sut.fetchTaskList(.inMemory) {}
        
        //Then
        XCTAssertTrue(sut.numberOfSection >= 1)
    }
    
    func test_Button_Press() {
        //Given
        XCTAssertTrue(sut.status.value)
        
        //When
        sut.sortButtonPressed()
        
        //Then
        XCTAssertFalse(sut.status.value)
    }
    
    func test_Title_For_Alert() {
        XCTAssertEqual(sut.titleForAlert(nil), "New List")
        XCTAssertEqual(sut.titleForAlert(TaskLists()), "Edit List")
        XCTAssertNotEqual(sut.titleForAlert(nil), sut.titleForAlert(TaskLists()))
    }
    
    func test_Get_TaskList() {
        //Given
        test_Fetch_TaskList()
        let index = IndexPath(row: 0, section: 0)
        
        //When
        let list = sut.getTaskList(for: index)
        
        //Then
        XCTAssertEqual(list.name, "foo")
        XCTAssertNotNil(list.date)
    }
    
    func test_Get_Tasks_ViewModel() {
        //Given
        test_Fetch_TaskList()
        let index = IndexPath(row: 0, section: 0)
        
        //When
        let list = sut.getTaskViewModel(at: index)
        
        //Then
        XCTAssertEqual(list.taskName, "foo")
    }
    
    func test_Sort_TaskList_Name_up() {
        //Given
        test_Get_TaskList()
        
        //When
        sut.sortTaskList(type: .name) {}
        
        //Then
        let index = IndexPath(row: 0, section: 0)
        let list = sut.getTaskList(for: index)
        XCTAssertEqual(list.name, "bar")
    }
    
    func test_Sort_TaskList_Name_down() {
        //Given
        test_Sort_TaskList_Name_up()
        test_Button_Press()
        
        //When
        sut.sortTaskList(type: .name) {}
        
        //Then
        let index = IndexPath(row: 0, section: 0)
        let list = sut.getTaskList(for: index)
        XCTAssertEqual(list.name, "foo")
    }
    
    func test_check_text_isEmpty() {
        //Given
        let text = "Foo Bar Baz"
        let textIsEmpty = ""
        
        //When and Then
        XCTAssertTrue(sut.checkingIsEmpty(textField: text))
        XCTAssertFalse(sut.checkingIsEmpty(textField: textIsEmpty))
    }
    
    func testTaskLists() {
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
}
