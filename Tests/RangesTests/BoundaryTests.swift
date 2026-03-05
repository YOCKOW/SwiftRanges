/***************************************************************************************************
 PartialRangeGreaterThanTests.swift
   © 2018-2019,2024-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Testing
@testable import Ranges

@Suite struct BoundaryTests {
  @Test func initialization() {
    let boundary1: GeneralizedRangeBound<Character> = .included("A")
    let boundary2: GeneralizedRangeBound<Character> = .included("Z")

    #expect(boundary1 != boundary2)
  }

  @Test func comparison() {
    let boundary1: GeneralizedRangeBound<Int> = .included(0)
    let boundary2: GeneralizedRangeBound<Int> = .excluded(0)
    let boundary3: GeneralizedRangeBound<Int> = .included(1)
    let boundary4: GeneralizedRangeBound<Int> = .excluded(1)
    let boundary5: GeneralizedRangeBound<Int> = .included(2)
    let boundary6: GeneralizedRangeBound<Int> = .excluded(2)

    #expect(boundary1._compare(boundary1, side: .lower) == .definitelyOrderedSame)
    #expect(boundary1._compare(boundary2, side: .lower) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary3, side: .lower) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary4, side: .lower) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary5, side: .lower) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary6, side: .lower) == .definitelyOrderedAscending)

    #expect(boundary1._compare(boundary1, side: .upper) == .definitelyOrderedSame)
    #expect(boundary1._compare(boundary2, side: .upper) == .definitelyOrderedDescending)
    #expect(boundary1._compare(boundary3, side: .upper) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary4, side: .upper) == .orderedAscendingButConsideredEquivalent)
    #expect(boundary1._compare(boundary5, side: .upper) == .definitelyOrderedAscending)
    #expect(boundary1._compare(boundary6, side: .upper) == .definitelyOrderedAscending)

    #expect(boundary3._compare(boundary1, side: .lower) == .definitelyOrderedDescending)
    #expect(boundary3._compare(boundary1, side: .upper) == .definitelyOrderedDescending)
    #expect(boundary3._compare(boundary2, side: .lower) == .orderedDescendingButConsideredEquivalent)
    #expect(boundary3._compare(boundary2, side: .upper) == .definitelyOrderedDescending)

    #expect(boundary4._compare(boundary1, side: .lower) == .definitelyOrderedDescending)
    #expect(boundary4._compare(boundary1, side: .upper) == .orderedDescendingButConsideredEquivalent)
    #expect(boundary4._compare(boundary2, side: .lower) == .definitelyOrderedDescending)
    #expect(boundary4._compare(boundary2, side: .upper) == .definitelyOrderedDescending)

    #expect(_min(boundary1, boundary2, boundary3, boundary4, boundary5, boundary6, side: .lower) == boundary1)
    #expect(_min(boundary1, boundary2, boundary3, boundary4, boundary5, boundary6, side: .upper) == boundary2)
    #expect(_max(boundary1, boundary2, boundary3, boundary4, boundary5, boundary6, side: .lower) == boundary6)
    #expect(_max(boundary1, boundary2, boundary3, boundary4, boundary5, boundary6, side: .upper) == boundary5)
  }
}
