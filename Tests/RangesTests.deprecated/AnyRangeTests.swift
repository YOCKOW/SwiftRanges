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
  
  func testConcatenation() {
    let upTo10 = AnyRange<Int>(..<10)
    let through10 = AnyRange<Int>(...10)
    let upTo30 = AnyRange<Int>(..<30)
    let through30 = AnyRange<Int>(...30)
    
    let from10 = AnyRange<Int>(10...)
    let greater10 = AnyRange<Int>(10<..)
    let from30 = AnyRange<Int>(30...)
    let greater30 = AnyRange<Int>(30<..)
    
    let closed = AnyRange<Int>(20...25)
    let leftOpen = AnyRange<Int>(20<..25)
    let open = AnyRange<Int>(20<.<25)
    let range = AnyRange<Int>(20..<25)
    
    let ranges: [AnyRange<Int>] = [
      upTo10, through10, upTo30, through30,
      from10, greater10, from30, greater30,
      closed, leftOpen, open, range
    ]
    
    for rr in ranges {
      XCTAssertEqual(rr.concatenated(with:.empty), rr)
      XCTAssertEqual(rr.concatenated(with:.unbounded), .unbounded)
    }
    
    XCTAssertNil(upTo10.concatenated(with:greater10))
    XCTAssertEqual(through10.concatenated(with:greater10), .unbounded)
    XCTAssertEqual(upTo30.concatenated(with:closed), AnyRange<Int>(..<30))
    XCTAssertEqual(open.concatenated(with:greater10), AnyRange<Int>(10<..))
    XCTAssertNil(range.concatenated(with:from30))
    
    // TODO: Add more test cases
  }
  
  func testIntersection() {
    XCTAssertEqual(AnyRange<Int>(..<10).intersection(AnyRange<Int>(5...)), AnyRange<Int>(5..<10))
    XCTAssertEqual(AnyRange<Int>(..<10).intersection(AnyRange<Int>(9<..)), .empty)
    XCTAssertEqual(AnyRange<Int>(20<.<40).intersection(AnyRange<Int>(30<..60)), AnyRange<Int>(30<.<40))
    XCTAssertEqual(AnyRange<Int>(50...).intersection(AnyRange<Int>(30<.<60)),  AnyRange<Int>(50..<60))
    // TODO: Add more test cases
  }
  
  
  func testSubtracting() {
    let equal: ((AnyRange<Int>, AnyRange<Int>?), (AnyRange<Int>, AnyRange<Int>?)) -> Bool = {
      return $0.0 == $1.0 && $0.1 == $1.1
    }
    
    XCTAssertTrue(equal(
      AnyRange<Int>(...).subtracting(AnyRange<Int>(10...20)),
      (AnyRange<Int>(..<10), AnyRange<Int>(20<..))
    ))
    
    XCTAssertTrue(equal(
      AnyRange<Int>(...100).subtracting(AnyRange<Int>(10<.<20)),
      (AnyRange<Int>(...10), AnyRange<Int>(20...100))
    ))
    
    
    XCTAssertTrue(equal(
      AnyRange<Int>(10<..).subtracting(AnyRange<Int>(20<..100)),
      (AnyRange<Int>(10<..20), AnyRange<Int>(100<..))
    ))
    
    XCTAssertTrue(equal(
      AnyRange<Int>(10..<100).subtracting(AnyRange<Int>(20..<90)),
      (AnyRange<Int>(10..<20), AnyRange<Int>(90..<100))
    ))

    XCTAssertTrue(equal(
      AnyRange<Int>(10..<100).subtracting(AnyRange<Int>(20..<90)),
      (AnyRange<Int>(10..<20), AnyRange<Int>(90..<100))
    ))
    
    
    XCTAssertTrue(equal(
      AnyRange<Int>(10..<100).subtracting(AnyRange<Int>(...90)),
      (AnyRange<Int>(90<.<100), nil)
    ))
    
    // TODO: Add more test cases
  }
  
  static var allTests = [
    ("testInitialization", testInitialization),
    ("testOverlaps", testOverlaps),
    ("testComparison", testComparison),
    ("testConcatenation", testConcatenation),
    ("testIntersection", testIntersection),
    ("testSubtracting", testSubtracting),
  ]
}

