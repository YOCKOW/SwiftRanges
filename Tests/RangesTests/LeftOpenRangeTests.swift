/***************************************************************************************************
 LeftOpenRangeTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class LeftOpenRangeTests: XCTestCase {
  func testAsRangeExpression() {
    let leftOpenRange =  0<..5 // cannot be "0 <..5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(leftOpenRange.contains(0))
    XCTAssertTrue(leftOpenRange.contains(5))
    
    let rel = leftOpenRange.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  func testAsGeneralizedRange() {
    let bounds = (0<..5).bounds
    
    XCTAssertNotNil(bounds)
    XCTAssertNotNil(bounds?.lower)
    XCTAssertEqual(bounds?.lower?.bound, 0)
    XCTAssertEqual(bounds?.lower?.isIncluded, false)
    XCTAssertNotNil(bounds?.upper)
    XCTAssertEqual(bounds?.upper?.bound, 5)
    XCTAssertEqual(bounds?.upper?.isIncluded, true)
  }
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
    ("testAsGeneralizedRange", testAsGeneralizedRange),
  ]
}

