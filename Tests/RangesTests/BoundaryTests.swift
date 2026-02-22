/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018-2019,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Testing
@testable import Ranges

@Suite struct BoundaryTests {
  @Test func initialization() {
    let boundary1: Boundary<Character> = .included("A")
    let boundary2: Boundary<Character> = .included("Z")

    #expect(boundary1 != boundary2)
  }

  @Test func comparison() {
    let boundary1: Boundary<Int> = .included(0)
    let boundary2: Boundary<Int> = .excluded(0)
    let boundary3: Boundary<Int> = .included(1)
    let boundary4: Boundary<Int> = .excluded(1)

    #expect(boundary1._compare(boundary1, side: .lower) == .orderedSame)
    #expect(boundary1._compare(boundary2, side: .lower) == .orderedAscending)
    #expect(boundary1._compare(boundary2, side: .upper) == .orderedDescending)
    #expect(boundary1._compare(boundary3, side: .upper) == .orderedAscending)

    #expect(_min(boundary1, boundary2, boundary3, boundary4, side: .lower) == boundary1)
    #expect(_min(boundary1, boundary2, boundary3, boundary4, side: .upper) == boundary2)
    #expect(_max(boundary1, boundary2, boundary3, boundary4, side: .lower) == boundary4)
    #expect(_max(boundary1, boundary2, boundary3, boundary4, side: .upper) == boundary3)
  }
}
