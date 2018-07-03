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
  
  
  // `Int` conforms to `Strideable` and its `Stride` conforms to `BinaryInteger`
  let intLOR: LeftOpenRange<Int> = 10<..20
  // `Double` also conforms to `Strideable` but its `Stride` doesn't confom to `BinaryInteger`
  let doubleLOR: LeftOpenRange<Double> = 1.0<..2.0
  
  func testOverlaps_ClosedRange() {
    let intCR: [(ClosedRange<Int>, Bool)] = [
      (0...10, false),
      (0...11, true),
      (0...30, true),
      (20...30, true),
      (30...40, false),
    ]
    let doubleCR: [(ClosedRange<Double>, Bool)] = [
      (0...1.0, false),
      (0...1.1, true),
      (0...3.0, true),
      (2.0...3.0, true),
      (3.0...4.0, false),
    ]
    for (closedRange, expected) in intCR {
      XCTAssertEqual(intLOR.overlaps(closedRange), expected,
                     "LeftOpenRange:\(intLOR), ClosedRange:\(closedRange)")
      XCTAssertEqual(closedRange.overlaps(intLOR), expected,
                     "LeftOpenRange:\(intLOR), ClosedRange:\(closedRange)")
    }
    for (closedRange, expected) in doubleCR {
      XCTAssertEqual(doubleLOR.overlaps(closedRange), expected,
                     "LeftOpenRange:\(doubleLOR), ClosedRange:\(closedRange)")
      XCTAssertEqual(closedRange.overlaps(doubleLOR), expected,
                     "LeftOpenRange:\(doubleLOR), ClosedRange:\(closedRange)")
    }
  }
  
  func testOverlaps_Range() {
    let intR: [(Range<Int>, Bool)] = [
      (0..<10, false),
      (0..<11, false),
      (0..<30, true),
      (20..<30, true),
      (30..<40, false),
    ]
    let doubleR: [(Range<Double>, Bool)] = [
      (0..<1.0, false),
      (0..<1.1, true),
      (0..<3.0, true),
      (2.0..<3.0, true),
      (3.0..<4.0, false),
    ]
    for (range, expected) in intR {
      XCTAssertEqual(intLOR.overlaps(range), expected,
                     "LeftOpenRange:\(intLOR), Range:\(range)")
      XCTAssertEqual(range.overlaps(intLOR), expected,
                     "LeftOpenRange:\(intLOR), Range:\(range)")
    }
    for (range, expected) in doubleR {
      XCTAssertEqual(doubleLOR.overlaps(range), expected,
                     "LeftOpenRange:\(doubleLOR), Range:\(range)")
      XCTAssertEqual(range.overlaps(doubleLOR), expected,
                     "LeftOpenRange:\(doubleLOR), Range:\(range)")
    }
    
  }
  
  static var allTests = [
    ("testAsRangeExpression", testAsRangeExpression),
    ("testOverlaps_ClosedRange", testOverlaps_ClosedRange),
    ("testOverlaps_Range", testOverlaps_Range),
  ]
}

