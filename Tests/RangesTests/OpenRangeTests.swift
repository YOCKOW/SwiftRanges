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
    let openRange =  0<..<5 // cannot be "0 <..<5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(openRange.contains(0))
    XCTAssertTrue(openRange.contains(3))
    XCTAssertFalse(openRange.contains(5))
    
    let rel = openRange.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  func testAsGeneralizedRange() {
    let bounds = (0<..<5).bounds
    
    XCTAssertNotNil(bounds)
    XCTAssertNotNil(bounds?.lower)
    XCTAssertEqual(bounds?.lower?.bound, 0)
    XCTAssertEqual(bounds?.lower?.isIncluded, false)
    XCTAssertNotNil(bounds?.upper)
    XCTAssertEqual(bounds?.upper?.bound, 5)
    XCTAssertEqual(bounds?.upper?.isIncluded, false)
  }
  
  func testEmptiness() {
    XCTAssertTrue(CountableOpenRange(uncheckedBounds:(lower:10, upper:10)).isEmpty)
    XCTAssertTrue(CountableOpenRange(uncheckedBounds:(lower:10, upper:11)).isEmpty) // empty!!
    XCTAssertFalse(CountableOpenRange(uncheckedBounds:(lower:10, upper:12)).isEmpty)
    
    XCTAssertTrue(OpenRange(uncheckedBounds:(lower:1.0, upper:1.0)).isEmpty)
    XCTAssertFalse(OpenRange(uncheckedBounds:(lower:1.0, upper:1.1)).isEmpty)
    XCTAssertFalse(OpenRange(uncheckedBounds:(lower:1.0, upper:1.2)).isEmpty)
  }
  
  
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
    ("testAsGeneralizedRange", testAsGeneralizedRange),
    ("testEmptiness", testEmptiness),
  ]
}


