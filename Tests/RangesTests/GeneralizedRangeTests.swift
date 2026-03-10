/* *************************************************************************************************
 GeneralizedRangeTests.swift
   © 2018-2019,2024-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Testing
@testable import Ranges

@Suite struct GeneralizedRangeTests {
  @Test func countability() {
    #expect(!(0.00..<1.0)._isCountable)
    #expect((0..<1)._isCountable)
  }

  @Test func makeRange() {
    func __check<B, R>(
      lower: GeneralizedRangeBound<B>,
      upper: GeneralizedRangeBound<B>,
      type: R.Type,
      _ comment: @autoclosure () -> Comment? = nil,
      sourceLocation: SourceLocation = #_sourceLocation
    ) where R: GeneralizedRange, R.Bound == B {
      #expect(
        Swift.type(of: _makeRange(uncheckedBounds: (lower: lower, upper: upper))) == type,
        comment(),
        sourceLocation: sourceLocation
      )
    }

    func __check<B, R>(
      lower: GeneralizedRangeBound<B>,
      upper: GeneralizedRangeBound<B>,
      type: R.Type,
      _ comment: @autoclosure () -> Comment? = nil,
      sourceLocation: SourceLocation = #_sourceLocation
    ) where B: Strideable, B.Stride: SignedInteger, R: GeneralizedCountableRange, R.Bound == B {
      #expect(
        Swift.type(of: _makeRange(uncheckedBounds: (lower: lower, upper: upper))) == type,
        comment(),
        sourceLocation: sourceLocation
      )
    }

    UNCOUNTABLE: do {
      let a: Unicode.Scalar = "a"
      let b: Unicode.Scalar = "b"

      __check(lower: .included(a), upper: .included(a), type: ClosedRange<Unicode.Scalar>.self)
      __check(lower: .excluded(a), upper: .included(a), type: EmptyRange<Unicode.Scalar>.self)
      __check(lower: .excluded(a), upper: .included(b), type: LeftOpenRange<Unicode.Scalar>.self)
      __check(lower: .excluded(a), upper: .excluded(a), type: EmptyRange<Unicode.Scalar>.self)
      __check(lower: .excluded(a), upper: .excluded(b), type: OpenRange<Unicode.Scalar>.self)
      __check(lower: .included(a), upper: .unbounded, type: PartialRangeFrom<Unicode.Scalar>.self)
      __check(lower: .excluded(a), upper: .unbounded, type: PartialRangeGreaterThan<Unicode.Scalar>.self)
      __check(lower: .unbounded, upper: .included(b), type: PartialRangeThrough<Unicode.Scalar>.self)
      __check(lower: .unbounded, upper: .excluded(b), type: PartialRangeUpTo<Unicode.Scalar>.self)
      __check(lower: .included(a), upper: .excluded(a), type: EmptyRange<Unicode.Scalar>.self)
      __check(lower: .included(a), upper: .excluded(b), type: Range<Unicode.Scalar>.self)
      __check(lower: .unbounded, upper: .unbounded, type: TangibleUnboundedRange<Unicode.Scalar>.self)
    }

    COUNTABLE: do {
      let one: Int = 1
      let two: Int = 2
      let three: Int = 3

      __check(lower: .included(one), upper: .included(one), type: ClosedRange<Int>.self)
      __check(lower: .excluded(one), upper: .included(one), type: EmptyRange<Int>.self)
      __check(lower: .excluded(one), upper: .included(two), type: LeftOpenRange<Int>.self)
      __check(lower: .excluded(one), upper: .excluded(one), type: EmptyRange<Int>.self)
      __check(lower: .excluded(one), upper: .excluded(two), type: EmptyRange<Int>.self)
      __check(lower: .excluded(one), upper: .excluded(three), type: OpenRange<Int>.self)
      __check(lower: .included(one), upper: .unbounded, type: PartialRangeFrom<Int>.self)
      __check(lower: .excluded(one), upper: .unbounded, type: PartialRangeGreaterThan<Int>.self)
      __check(lower: .unbounded, upper: .included(three), type: PartialRangeThrough<Int>.self)
      __check(lower: .unbounded, upper: .excluded(three), type: PartialRangeUpTo<Int>.self)
      __check(lower: .included(one), upper: .excluded(one), type: EmptyRange<Int>.self)
      __check(lower: .included(one), upper: .excluded(two), type: Range<Int>.self)
      __check(lower: .unbounded, upper: .unbounded, type: TangibleUnboundedRange<Int>.self)
    }
  }

  @Test func comparison() {
    #expect(!EmptyRange<Double>().isEqual(to: TangibleUnboundedRange<Double>()))
    #expect(EmptyRange<Int>().compare(TangibleUnboundedRange<Int>()) == .orderedDescending)
    #expect((0...10).compare(0..<10) == .orderedDescending)
    #expect(TangibleUnboundedRange<Int>().compare(100...200) == .orderedAscending)
    #expect(EmptyRange<Int>().compare(...) == .orderedDescending)

    #expect(EmptyRange<Double>().isEqual(to:  ()))
    #expect(!(10..<20).isEqual(to: 10...19))
    #expect((10..<20).isEquivalent(to: 10...19))
    #expect((99<..<201).isEquivalent(to: 100...200))
  }

  @Test func intersection() {
    #expect((0..<10).intersection(5<..15).isEqual(to: 5<..<10))
    #expect((0..<10).intersection(10..<15).isEqual(to: EmptyRange<Int>()))
    #expect((0...).intersection(..<15).isEqual(to: 0..<15))
    #expect((..<100).intersection(90<..).isEqual(to: 90<..<100))
    #expect((..<100).intersection(99<..).isEmpty)

    #expect((0...100).intersection(()).isEmpty)
    #expect((0...100).intersection((...)).isEqual(to: 0...100))
  }

  @Test func overlaps() {
    #expect(!(0...100).overlaps(()))
    #expect((0...100).overlaps(...))
    #expect((0...100).overlaps(10<..<20))
    #expect(!(0...100).overlaps(100<..<200))
  }

  @Test func concatenation() throws {
    #expect((0..<100).concatenating(100<..200) == nil)
    #expect(try #require((0..<100).concatenating(100..<200)).isEqual(to: 0..<200))
    #expect(try #require((0...99).concatenating(100..<200)).isEqual(to: 0..<200)) // Countable!
    #expect(try #require((...400).concatenating(100..<200)).isEqual(to: ...400))
    #expect(try #require((0<..<10).concatenating(())).isEqual(to: 0<..<10))
    #expect(try #require((...400).concatenating(100...)).isEqual(to: ...))
  }

  @Test func subtraction() throws {
    var subtracted = (0...100).subtracting(20...80)
    #expect(subtracted.0.isEqual(to: 0..<20))
    #expect(try #require(subtracted.1).isEqual(to: (80<..100)))

    subtracted = TangibleUnboundedRange<Int>().subtracting(20<..<80)
    #expect(subtracted.0.isEqual(to: ...20))
    #expect(try #require(subtracted.1).isEqual(to: 80...))

    subtracted = (10<..<20).subtracting(11...19)
    #expect(subtracted.0.isEmpty)
    #expect(subtracted.1 == nil)

    subtracted = (..<20).subtracting(35...55)
    #expect(subtracted.0.isEqual(to: ..<20))
    #expect(subtracted.1 == nil)

    subtracted = (10<..<20).subtracting(0..<11)
    #expect(subtracted.0.isEqual(to: 11..<20))
    #expect(subtracted.1 == nil)
  }
}
