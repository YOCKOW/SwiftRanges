/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class PartialRangeGreaterThanTests: XCTestCase {
  func test_asRangeExpression() {
    let partialRangeGreaterThan: PartialRangeGreaterThan<Int> =  5<.. // cannot be "5 <.."
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(partialRangeGreaterThan.contains(0))
    XCTAssertFalse(partialRangeGreaterThan.contains(5))
    XCTAssertTrue(partialRangeGreaterThan.contains(Int.max))
    
    let rel = partialRangeGreaterThan.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  func test_asGeneralizedRange() {
    let bounds = (0<..).bounds
    
    XCTAssertNotNil(bounds)
    XCTAssertEqual(bounds?.lower, .excluded(0))
    XCTAssertEqual(bounds?.upper, .unbounded)
  }
}


