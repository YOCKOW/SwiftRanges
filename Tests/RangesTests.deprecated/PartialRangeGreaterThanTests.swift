/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class PartialRangeGreaterThanTests: XCTestCase {
  func testAsRangeExpression() {
    let partialRangeGreaterThan =  5<.. // cannot be "5 <.."
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(partialRangeGreaterThan.contains(0))
    XCTAssertFalse(partialRangeGreaterThan.contains(5))
    XCTAssertTrue(partialRangeGreaterThan.contains(Int.max))
    
    let rel = partialRangeGreaterThan.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
  ]
}

