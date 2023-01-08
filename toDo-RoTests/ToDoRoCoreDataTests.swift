//
//  TaskListsTests.swift
//  toDo-RoTests
//
//  Created by Илья on 20.12.2022.
//

import XCTest
@testable import toDo_Ro

final class TaskListsTests: XCTestCase {
    
    var sut: TaskListViewModel!
    
    override func setUp() {
        super.setUp()
        sut = TaskListViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExample() {
    }

    func testPerformanceExample() {
        self.measure {
           
        }
    }
}

extension TaskListsTests {
}
