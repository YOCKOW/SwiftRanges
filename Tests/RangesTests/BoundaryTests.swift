/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class BoundaryTests: XCTestCase {
  func test_initialization() {
    let boundary1: Boundary<Character> = .included("A")
    let boundary2: Boundary<Character> = .included("Z")
    
    XCTAssertNotEqual(boundary1, boundary2)
  }
  
  func test_comparison() {
    let boundary1: Boundary<Int> = .included(0)
    let boundary2: Boundary<Int> = .excluded(0)
    let boundary3: Boundary<Int> = .included(1)
    let boundary4: Boundary<Int> = .excluded(1)
    
    XCTAssertEqual(boundary1._compare(boundary1, side: .lower), .orderedSame)
    XCTAssertEqual(boundary1._compare(boundary2, side: .lower), .orderedAscending)
    XCTAssertEqual(boundary1._compare(boundary2, side: .upper), .orderedDescending)
    XCTAssertEqual(boundary1._compare(boundary3, side: .upper), .orderedAscending)
    
    
    XCTAssertEqual(_min(boundary1, boundary2, boundary3, boundary4, side: .lower),
                   boundary1)
    XCTAssertEqual(_min(boundary1, boundary2, boundary3, boundary4, side: .upper),
                   boundary2)
    XCTAssertEqual(_max(boundary1, boundary2, boundary3, boundary4, side: .lower),
                   boundary4)
    XCTAssertEqual(_max(boundary1, boundary2, boundary3, boundary4, side: .upper),
                   boundary3)
  }
}


