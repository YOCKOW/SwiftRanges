/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class BoundaryTests: XCTestCase {
  func testInitialization() {
    let bound1 = Boundary<Character>(bound:"A", isIncluded:true)
    let bound2 = Boundary<Character>(bound:"Z", isIncluded:true)
    
    XCTAssertNotEqual(bound1, bound2)
  }
  
  static var allTests = [
    ("testInitialization", testInitialization),
  ]
}


