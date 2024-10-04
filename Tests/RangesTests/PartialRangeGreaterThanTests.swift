/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018-2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct PartialRangeGreaterThanTests {
  @Test func asRangeExpression() {
    let partialRangeGreaterThan: PartialRangeGreaterThan<Int> =  5<.. // cannot be "5 <.."
    let array = [0,1,2,3,4,5,6,7,8,9,10]

    #expect(!partialRangeGreaterThan.contains(0))
    #expect(!partialRangeGreaterThan.contains(5))
    #expect(partialRangeGreaterThan.contains(Int.max))

    let rel = partialRangeGreaterThan.relative(to:array)
    #expect(rel == rel.relative(to:array))
  }

  @Test func asGeneralizedRange() throws {
    let bounds = try #require((0<..).bounds)

    #expect(bounds.lower == .excluded(0))
    #expect(bounds.upper == .unbounded)
  }
}
#else
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
#endif
