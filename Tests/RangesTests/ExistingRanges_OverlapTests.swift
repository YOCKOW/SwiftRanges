/***************************************************************************************************
 ExistingRanges_OverlapTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class ExistingRanges_OverlapTests: XCTestCase {
  func test_ClosedRange() {
    let closedRange: ClosedRange<Int> = 20...40
    
    // ClosedRange vs PartialRangeFrom
    XCTAssertTrue(closedRange.overlaps(10...))
    XCTAssertTrue(closedRange.overlaps(30...))
    XCTAssertFalse(closedRange.overlaps(50...))
    
    // ClosedRange vs PartialRangeThrough
    XCTAssertFalse(closedRange.overlaps(...10))
    XCTAssertTrue(closedRange.overlaps(...30))
    XCTAssertTrue(closedRange.overlaps(...50))
    
    // ClosedRange vs PartialRangeUpTo
    XCTAssertFalse(closedRange.overlaps(..<10))
    XCTAssertFalse(closedRange.overlaps(..<20))
    XCTAssertTrue(closedRange.overlaps(..<30))
    XCTAssertTrue(closedRange.overlaps(..<50))
  }
  
  func test_Range() {
    let range: Range<Int> = 20..<40
    
    // Range vs PartialRangeFrom
    XCTAssertTrue(range.overlaps(10...))
    XCTAssertTrue(range.overlaps(30...))
    XCTAssertFalse(range.overlaps(40...))
    XCTAssertFalse(range.overlaps(50...))
    
    // Range vs PartialRangeThrough
    XCTAssertFalse(range.overlaps(...10))
    XCTAssertTrue(range.overlaps(...30))
    XCTAssertTrue(range.overlaps(...50))
    
    // Range vs PartialRangeUpTo
    XCTAssertFalse(range.overlaps(..<10))
    XCTAssertFalse(range.overlaps(..<20))
    XCTAssertTrue(range.overlaps(..<30))
    XCTAssertTrue(range.overlaps(..<50))
  }
  
  func test_PartialRangeFrom() {
    let range: PartialRangeFrom<Int> = 20...
    
    // vs PartialRangeThrough
    XCTAssertFalse(range.overlaps(...10))
    XCTAssertTrue(range.overlaps(...30))
    XCTAssertTrue(range.overlaps(...50))
    
    // vs PartialRangeUpTo
    XCTAssertFalse(range.overlaps(..<10))
    XCTAssertFalse(range.overlaps(..<20))
    XCTAssertTrue(range.overlaps(..<30))
    XCTAssertTrue(range.overlaps(..<50))
  }
  
  static var allTests = [
    ("test_ClosedRange", test_ClosedRange),
    ("test_Range", test_Range),
    ("test_PartialRangeFrom", test_PartialRangeFrom),
  ]
}
