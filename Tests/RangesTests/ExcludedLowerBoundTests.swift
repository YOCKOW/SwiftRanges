/***************************************************************************************************
 ExcludedLowerBoundTests.swift
   © 2018,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Testing
@testable import Ranges

@Suite struct ExcludedLowerBoundTests {
  @Test func functions() {
    let abc = "ABC"<
    #expect(abc.lowerBound == "ABC")
  }
}
