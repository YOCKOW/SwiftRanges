/* *************************************************************************************************
 GeneralizedRangeTests.swift
   © 2018-2019,2024-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Testing
@testable import Ranges

@Suite struct GeneralizedRangeTests {
  @Test func makeRange() {
    UNCOUNTABLE: do {
      let a: Unicode.Scalar = "a"
      let b: Unicode.Scalar = "b"

      #expect(_makeUncountableRange((lower: .included(a), upper: .included(a))) is ClosedRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .excluded(a), upper: .included(a))) is EmptyRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .excluded(a), upper: .included(b))) is LeftOpenRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .excluded(a), upper: .excluded(a))) is EmptyRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .excluded(a), upper: .excluded(b))) is OpenRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .included(a), upper: .unbounded)) is PartialRangeFrom<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .excluded(a), upper: .unbounded)) is PartialRangeGreaterThan<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .unbounded, upper: .included(b))) is PartialRangeThrough<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .unbounded, upper: .excluded(b))) is PartialRangeUpTo<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .included(a), upper: .excluded(a))) is EmptyRange<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: .included(a), upper: .excluded(b))) is Range<Unicode.Scalar>)
      #expect(_makeUncountableRange((lower: GeneralizedRangeBound<Unicode.Scalar>.unbounded, upper: .unbounded)) is TangibleUnboundedRange<Unicode.Scalar>)
    }

    COUNTABLE: do {
      let one: Int = 1
      let two: Int = 2
      let three: Int = 3

      #expect(_makeCountableRange((lower: .included(one), upper: .included(one))) is ClosedRange<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .included(one))) is EmptyRange<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .included(two))) is LeftOpenRange<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .excluded(one))) is EmptyRange<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .excluded(two))) is EmptyRange<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .excluded(three))) is OpenRange<Int>)
      #expect(_makeCountableRange((lower: .included(one), upper: .unbounded)) is PartialRangeFrom<Int>)
      #expect(_makeCountableRange((lower: .excluded(one), upper: .unbounded)) is PartialRangeGreaterThan<Int>)
      #expect(_makeCountableRange((lower: .unbounded, upper: .included(three))) is PartialRangeThrough<Int>)
      #expect(_makeCountableRange((lower: .unbounded, upper: .excluded(three))) is PartialRangeUpTo<Int>)
      #expect(_makeCountableRange((lower: .included(one), upper: .excluded(one))) is EmptyRange<Int>)
      #expect(_makeCountableRange((lower: .included(one), upper: .excluded(two))) is Range<Int>)
      #expect(_makeCountableRange((lower: GeneralizedRangeBound<Int>.unbounded, upper: .unbounded)) is TangibleUnboundedRange<Int>)
    }
  }

  @Test func wellknownRange() {
    struct MyRange<Bound>: GeneralizedRange where Bound: Comparable {
      var bounds: Bounds<Bound>?
      init(bounds: Bounds<Bound>?) {
        self.bounds = bounds
      }
      init(lower: GeneralizedRangeBound<Bound>, upper: GeneralizedRangeBound<Bound>) {
        self.init(bounds: (lower: lower, upper: upper))
      }
      init<R>(range: R) where R: GeneralizedRange, R.Bound == Bound {
        self.init(bounds: range.bounds)
      }
    }

    let myScalarRange1 = MyRange<Unicode.Scalar>(lower: .excluded("A"), upper: .excluded("B"))
    #expect(myScalarRange1._wellknownRange is OpenRange<Unicode.Scalar>)

    let myScalarRange2 = MyRange<Unicode.Scalar>(lower: .excluded("C"), upper: .excluded("C"))
    #expect(myScalarRange2._wellknownRange is EmptyRange<Unicode.Scalar>)

    let myIntRange1 = MyRange<Int>(range: 0..<100)
    #expect(myIntRange1._wellknownRange is Range<Int>)

    let myIntRange2 = MyRange<Int>(lower: .excluded(0), upper: .excluded(1))
    #expect(myIntRange2._wellknownRange is EmptyRange<Int>) // Because `Int` is `Strideable`!
  }

  @Test func comparison() {
    #expect(EmptyRange<Double>() != TangibleUnboundedRange<Double>())
    #expect(EmptyRange<Int>() > TangibleUnboundedRange<Int>())
    #expect(0...10 > 0..<10)

    #expect(EmptyRange<Double>() == ())
    #expect(() == EmptyRange<Int>())
    #expect(10..<20 < ())
    #expect((...) <= 100...200)
    #expect((...) < ())

    // TODO: Add more test cases
  }

  @Test func intersection() {
    #expect((0..<10).intersection(5<..15) == 5<..<10)
    #expect((0..<10).intersection(10..<15) == EmptyRange<Int>())
    #expect((0...).intersection(..<15) == 0..<15)
    #expect((..<100).intersection(90<..) == 90<..<100)
    #expect((..<100).intersection(99<..) == .empty)

    #expect((0...100).intersection(()) == .empty)
    #expect((0...100).intersection((...)) == 0...100)
  }

  @Test func overlaps() {
    #expect(!(0...100).overlaps(()))
    #expect((0...100).overlaps(...))
    #expect((0...100).overlaps(10<..<20))
    #expect(!(0...100).overlaps(100<..<200))
  }

  @Test func concatenation() {
    #expect((0..<100).concatenating(100<..200) == nil)
    #expect((0..<100).concatenating(100..<200) == 0..<200)
    #expect((...400).concatenating(100..<200) == ...400)
    #expect((0<..<10).concatenating(()) == 0<..<10)
    #expect((...400).concatenating(100...) == (...))
  }

  @Test func subtraction() {
    var subtracted = (0...100).subtracting(20...80)
    #expect(subtracted.0 == 0..<20)
    #expect(subtracted.1 == (80<..100))

    subtracted = TangibleUnboundedRange<Int>().subtracting(20<..<80)
    #expect(subtracted.0 == ...20)
    #expect(subtracted.1 == 80...)

    subtracted = (10<..<20).subtracting(11...19)
    #expect(subtracted.0 == .empty)
    #expect(subtracted.1 == nil)

    subtracted = (..<20).subtracting(35...55)
    #expect(subtracted.0 == ..<20)
    #expect(subtracted.1 == nil)

    subtracted = (10<..<20).subtracting(0..<11)
    #expect(subtracted.0 == 11..<20)
    #expect(subtracted.1 == nil)
  }
}
