/***************************************************************************************************
 ExcludedLowerBoundTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class ExcludedLowerBoundTests: XCTestCase {
  func test_functions() {
    let abc = "ABC"<
    XCTAssertEqual(abc.lowerBound, "ABC")
  }
}
