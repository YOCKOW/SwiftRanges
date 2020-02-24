/* *************************************************************************************************
 MemoizableMultipleRangesTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import Ranges

final class MemoizablesTests: XCTestCase {
  func test_ranges() {
    let normalRanges = MultipleRanges<Int>([0...<10, 100...<1000])
    let ranges = MemoizableMultipleRanges<Int>(normalRanges)
    XCTAssertTrue(ranges.contains(5))
    XCTAssertTrue(ranges.contains(555))
    XCTAssertFalse(ranges.contains(5555))
    XCTAssertTrue(ranges.contains(5)) // again
  }
  
  func test_dictionary() {
    let normalDictionary: RangeDictionary<Int, String> = [
      0...<10: "0",
      10...<20: "10",
      20...<30: "20",
    ]
    let dictionary = MemoizableRangeDictionary(normalDictionary)
    XCTAssertEqual(dictionary[5], "0")
    XCTAssertEqual(dictionary[15], "10")
    XCTAssertEqual(dictionary[25], "20")
    XCTAssertEqual(dictionary[10000], nil)
    XCTAssertEqual(dictionary[5], "0") // again
  }
}
