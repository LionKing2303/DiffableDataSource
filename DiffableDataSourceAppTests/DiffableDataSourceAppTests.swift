//
//  DiffableDataSourceAppTests.swift
//  DiffableDataSourceAppTests
//
//  Created by Arie Peretz on 26/06/2021.
//

import XCTest
@testable import DiffableDataSourceApp

class DiffableDataSourceAppTests: XCTestCase {

    func testSubscriber() {
        var output: [Int] = []
        let exp = expectation(description: "output")

        let publisher = [1,2,3].publisher
        let subscriber = CustomSubscriber<Int> { number in
            print(number)
            output.append(number)
            if output.count == 3 {
                exp.fulfill()
            }
        }
        publisher.subscribe(subscriber)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(output, [1,2,3])
    }
    
    func testViewModelWithSubscriber() {
        var output: [[Item]] = []
        var vm: ViewController.ViewModel? = ViewController.ViewModel()
        let exp = expectation(description: "view model")
        vm?.$items
            .execute { (items) in
                print(items)
                output.append(items)
                if output.count == 2 {
                    exp.fulfill()
                }
            }
        vm = nil
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(output, [
            [],
            [
                .parent(Parent(name: "Father")),
                .child(Child(nickname: "Little Bird", age: 18))
            ]
        ])
    }
}
