/***************************************************************************************************
 GeneralizedRangeTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class GeneralizedRangeTests: XCTestCase {
  func testComparison() {
    XCTAssertFalse(EmptyRange<Double>() == TangibleUnboundedRange<Double>())
    XCTAssertTrue(EmptyRange<Int>() > TangibleUnboundedRange<Int>())
    XCTAssertTrue(0...10 > 0..<10)
    
    XCTAssertTrue(EmptyRange<Double>() == ())
    XCTAssertTrue(() == EmptyRange<Int>())
    XCTAssertTrue(10..<20 < ())
    XCTAssertTrue((...) <= 100...200)
    XCTAssertTrue((...) < ())
    
    // TODO: Add more test cases
  }
  
  func testIntersection() {
    XCTAssertTrue((0..<10).intersection(5<..15) == 5<.<10)
    XCTAssertTrue((0..<10).intersection(10..<15) == EmptyRange<Int>())
    XCTAssertTrue((0...).intersection(..<15) == 0..<15)
    XCTAssertTrue((..<100).intersection(90<..) == 90<.<100)
    XCTAssertTrue((..<100).intersection(99<..) == .empty)
  }
  
  static var allTests = [
    ("testComparison", testComparison),
    ("testIntersection", testIntersection),
  ]
}

