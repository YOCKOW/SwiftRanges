/***************************************************************************************************
 GeneralizedRangeTests.swift
   © 2018-2019,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import Testing
@testable import Ranges

@Suite struct GeneralizedRangeTests {
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
