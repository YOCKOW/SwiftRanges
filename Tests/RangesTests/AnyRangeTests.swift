/***************************************************************************************************
 AnyRangeTests.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class AnyRangeTests: XCTestCase {
  func test_asRangeExpression() {
    // Default implementation is in "GeneralizedRange"
    
    let range1 = AnyRange<Int>(0..<1)
    XCTAssertTrue(range1.contains(0))
    XCTAssertFalse(range1.contains(1))
    
    let range2 = AnyRange<Int>(0<..<1)
    XCTAssertTrue(range2.isEmpty)
    let range2_1 = AnyRange<Double>(0<..<1)
    XCTAssertFalse(range2_1.isEmpty)
    
    let range3 = AnyRange<Int>(1<..)
    XCTAssertEqual(range3.relative(to:[0,1,2,3]), 2..<4)
  }
  
  func test_intersection() {
    func _forceUnbountableRange<R,B>(_ range: R) -> AnyRange<B> where R: GeneralizedRange, R.Bound == B {
      return AnyRange<B>(range)
    }
    
    XCTAssertEqual(AnyRange<Int>(0..<10).intersection(_forceUnbountableRange(9<..20)),
                   .empty)
    XCTAssertEqual(_forceUnbountableRange(0..<10).intersection(AnyRange<Int>(5<..20)),
                   AnyRange<Int>(5<..<10))
    XCTAssertEqual(_forceUnbountableRange(0..<10).intersection(.unbounded),
                   AnyRange<Int>(0..<10))
  }
}


