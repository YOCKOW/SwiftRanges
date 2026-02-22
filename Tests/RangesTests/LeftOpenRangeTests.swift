/***************************************************************************************************
 LeftOpenRangeTests.swift
   © 2018-2019,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Testing
@testable import Ranges

@Suite struct LeftOpenRangeTests {
  @Test func asRangeExpression() {
    let leftOpenRange: LeftOpenRange<Int> =  0<..5 // cannot be "0 <..5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]

    #expect(!leftOpenRange.contains(0))
    #expect(leftOpenRange.contains(5))

    let rel = leftOpenRange.relative(to:array)
    #expect(rel == rel.relative(to:array))
  }

  @Test func asGeneralizedRange() throws {
    let bounds = try #require((0<..5).bounds)

    #expect(bounds.lower == .excluded(0))
    #expect(bounds.upper == .included(5))
  }
}
