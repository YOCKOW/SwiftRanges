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
    let boundary1 = Boundary<Character>(bound:"A", isIncluded:true)
    let boundary2 = Boundary<Character>(bound:"Z", isIncluded:true)
    
    XCTAssertNotEqual(boundary1, boundary2)
  }
  
  func testComparison() {
    let boundary1 = Boundary<Int>(bound:0, isIncluded:true)
    let boundary2 = Boundary<Int>(bound:0, isIncluded:false)
    let boundary3 = Boundary<Int>(bound:1, isIncluded:true)
    let boundary4 = Boundary<Int>(bound:1, isIncluded:false)
    
    XCTAssertEqual(boundary1._compare(boundary1, as:.lower), .orderedSame)
    XCTAssertEqual(boundary1._compare(boundary2, as:.lower), .orderedAscending)
    XCTAssertEqual(boundary1._compare(boundary2, as:.upper), .orderedDescending)
    XCTAssertEqual(boundary1._compare(boundary3, as:.upper), .orderedAscending)
    
    
    XCTAssertEqual(_min(boundary1, boundary2, boundary3, boundary4, as:.lower),
                   boundary1)
    XCTAssertEqual(_min(boundary1, boundary2, boundary3, boundary4, as:.upper),
                   boundary2)
    XCTAssertEqual(_max(boundary1, boundary2, boundary3, boundary4, as:.lower),
                   boundary4)
    XCTAssertEqual(_max(boundary1, boundary2, boundary3, boundary4, as:.upper),
                   boundary3)
    
  }
  
  static var allTests = [
    ("testInitialization", testInitialization),
    ("testComparison", testComparison),
  ]
}


