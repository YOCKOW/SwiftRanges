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
  
  static var allTests = [
    ("testInitialization", testInitialization),
  ]
}

