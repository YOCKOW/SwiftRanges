/***************************************************************************************************
 OpenRangeTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class OpenRangeTests: XCTestCase {
  func testAsRangeExpression() {
    let openRange =  0<.<5 // cannot be "0 <.<5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(openRange.contains(0))
    XCTAssertTrue(openRange.contains(3))
    XCTAssertFalse(openRange.contains(5))
    
    let rel = openRange.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  func testEmptiness() {
    XCTAssertTrue((10<.<10).isEmpty)
    XCTAssertTrue((10<.<11).isEmpty)
    XCTAssertTrue((1.0<.<1.0).isEmpty)
    XCTAssertFalse((1.0<.<1.1).isEmpty)
  }
  
  
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
    ("testEmptiness", testEmptiness),
  ]
}


