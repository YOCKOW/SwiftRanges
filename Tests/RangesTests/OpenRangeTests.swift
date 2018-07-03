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
  
  // `Int` conforms to `Strideable` and its `Stride` conforms to `BinaryInteger`
  let intOR: OpenRange<Int> = 10<.<20
  // `Double` also conforms to `Strideable` but its `Stride` doesn't confom to `BinaryInteger`
  let doubleOR: OpenRange<Double> = 1.0<.<2.0
  
  func testOverlaps_ClosedRange() {
    let intCR: [(ClosedRange<Int>, Bool)] = [
      (0...10, false),
      (0...11, true),
      (15...25, true),
      (0...30, true),
      (20...30, false),
      (30...40, false),
    ]
    let doubleCR: [(ClosedRange<Double>, Bool)] = [
      (0...1.0, false),
      (0...1.1, true),
      (1.5...2.5, true),
      (0...3.0, true),
      (2.0...3.0, false),
      (3.0...4.0, false),
    ]
    for (closedRange, expected) in intCR {
      XCTAssertEqual(intOR.overlaps(closedRange), expected,
                     "OpenRange:\(intOR), ClosedRange:\(closedRange)")
      XCTAssertEqual(closedRange.overlaps(intOR), expected,
                     "OpenRange:\(intOR), ClosedRange:\(closedRange)")
    }
    for (closedRange, expected) in doubleCR {
      XCTAssertEqual(doubleOR.overlaps(closedRange), expected,
                     "OpenRange:\(doubleOR), ClosedRange:\(closedRange)")
      XCTAssertEqual(closedRange.overlaps(doubleOR), expected,
                     "OpenRange:\(doubleOR), ClosedRange:\(closedRange)")
    }
  }
  
  func testOverlaps_Range() {
    let intR: [(Range<Int>, Bool)] = [
      (0..<10, false),
      (0..<11, false),
      (15..<25, true),
      (0..<30, true),
      (20..<30, false),
      (30..<40, false),
    ]
    let doubleR: [(Range<Double>, Bool)] = [
      (0..<1.0, false),
      (0..<1.1, true),
      (1.5..<2.5, true),
      (0..<3.0, true),
      (2.0..<3.0, false),
      (3.0..<4.0, false),
    ]
    for (range, expected) in intR {
      XCTAssertEqual(intOR.overlaps(range), expected,
                     "OpenRange:\(intOR), Range:\(range)")
      XCTAssertEqual(range.overlaps(intOR), expected,
                     "OpenRange:\(intOR), Range:\(range)")
    }
    for (range, expected) in doubleR {
      XCTAssertEqual(doubleOR.overlaps(range), expected,
                     "OpenRange:\(doubleOR), Range:\(range)")
      XCTAssertEqual(range.overlaps(doubleOR), expected,
                     "OpenRange:\(doubleOR), Range:\(range)")
    }
    
  }
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
    ("testEmptiness", testEmptiness),
    ("testOverlaps_ClosedRange", testOverlaps_ClosedRange),
    ("testOverlaps_Range", testOverlaps_Range),
  ]
}


