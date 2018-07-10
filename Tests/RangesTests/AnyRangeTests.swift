/***************************************************************************************************
 AnyRangeTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class AnyRangeTests: XCTestCase {
  func testInitialization() {
    XCTAssertTrue(AnyRange<Character>().isEmpty)
    XCTAssertFalse(AnyRange<Character>(...).isEmpty)
    
    XCTAssertFalse(AnyRange<Int>(0..<10).isEmpty)
    XCTAssertTrue(AnyRange<Int>(0<.<1).isEmpty)
    XCTAssertFalse(AnyRange<Double>(0<.<1.0).isEmpty)
  }
  
  func testOverlaps() {
    // Detailed tests are in "OverlapTests.swift"
    
    XCTAssertFalse(AnyCountableRange<Int>(0..<10).overlaps(AnyCountableRange<Int>(9<..15)))
    XCTAssertFalse(AnyCountableRange<Int>(0..<10).overlaps(AnyCountableRange<Int>(9<.<15)))
    XCTAssertFalse(AnyCountableRange<Int>(0..<10).overlaps(AnyCountableRange<Int>(9<..)))
    
    XCTAssertFalse(AnyCountableRange<Int>(0<.<10).overlaps(AnyCountableRange<Int>(9<..15)))
    XCTAssertFalse(AnyCountableRange<Int>(0<.<10).overlaps(AnyCountableRange<Int>(9<.<15)))
    XCTAssertFalse(AnyCountableRange<Int>(0<.<10).overlaps(AnyCountableRange<Int>(9<..)))
  }
  
  
  func testComparison() {
    let ranges: [AnyRange<Int>] = [
      AnyRange<Int>(),
      AnyRange<Int>(40<..),
      AnyRange<Int>(40...),
      AnyRange<Int>(20...40),
      AnyRange<Int>(20<..40),
      AnyRange<Int>(20<.<40),
      AnyRange<Int>(20..<40),
      AnyRange<Int>(20...30),
      AnyRange<Int>(20<..30),
      AnyRange<Int>(20<.<30),
      AnyRange<Int>(20..<30),
      AnyRange<Int>(10...30),
      AnyRange<Int>(10<..30),
      AnyRange<Int>(10<.<30),
      AnyRange<Int>(10..<30),
      AnyRange<Int>(...20),
      AnyRange<Int>(..<20),
      AnyRange<Int>(...),
    ]
    
    let expected: [AnyRange<Int>] = [
      AnyRange<Int>(...),
      AnyRange<Int>(..<20),
      AnyRange<Int>(...20),
      AnyRange<Int>(10..<30),
      AnyRange<Int>(10...30),
      AnyRange<Int>(10<.<30),
      AnyRange<Int>(10<..30),
      AnyRange<Int>(20..<30),
      AnyRange<Int>(20...30),
      AnyRange<Int>(20..<40),
      AnyRange<Int>(20...40),
      AnyRange<Int>(20<.<30),
      AnyRange<Int>(20<..30),
      AnyRange<Int>(20<.<40),
      AnyRange<Int>(20<..40),
      AnyRange<Int>(40...),
      AnyRange<Int>(40<..),
      AnyRange<Int>(),
    ]
    
    let sorted = ranges.sorted(by:<)
    
    precondition(expected.count == sorted.count)
    
    for ii in 0..<expected.count {
      XCTAssertEqual(expected[ii], sorted[ii],
                     "\(ii); expected: \(expected[ii]), actual:\(sorted[ii])")
    }
  }
  
  
  static var allTests = [
    ("testInitialization", testInitialization),
    ("testOverlaps", testOverlaps),
    ("testComparison", testComparison),
  ]
}

