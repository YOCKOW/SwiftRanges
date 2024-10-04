/***************************************************************************************************
 ExcludedLowerBoundTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct ExcludedLowerBoundTests {
  @Test func functions() {
    let abc = "ABC"<
    #expect(abc.lowerBound == "ABC")
  }
}
#else
final class ExcludedLowerBoundTests: XCTestCase {
  func test_functions() {
    let abc = "ABC"<
    XCTAssertEqual(abc.lowerBound, "ABC")
  }
}
#endif
