/***************************************************************************************************
 GeneralizedRangeTests.swift
   © 2018-2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

#if swift(>=6) && canImport(Testing)
import Testing

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
#else
final class GeneralizedRangeTests: XCTestCase {
  func test_comparison() {
    XCTAssertFalse(EmptyRange<Double>() == TangibleUnboundedRange<Double>())
    XCTAssertTrue(EmptyRange<Int>() > TangibleUnboundedRange<Int>())
    XCTAssertTrue(0...10 > 0..<10)
    
    XCTAssertTrue(EmptyRange<Double>() == ())
    XCTAssertTrue(() == EmptyRange<Int>())
    XCTAssertTrue(10..<20 < ())
    XCTAssertTrue((...) <= 100...200)
    XCTAssertTrue((...) < ())
    
    // TODO: Add more test cases
  }
  
  func test_intersection() {
    XCTAssertTrue((0..<10).intersection(5<..15) == 5<..<10)
    XCTAssertTrue((0..<10).intersection(10..<15) == EmptyRange<Int>())
    XCTAssertTrue((0...).intersection(..<15) == 0..<15)
    XCTAssertTrue((..<100).intersection(90<..) == 90<..<100)
    XCTAssertTrue((..<100).intersection(99<..) == .empty)
    
    XCTAssertTrue((0...100).intersection(()) == .empty)
    XCTAssertTrue((0...100).intersection((...)) == 0...100)
  }
  
  func test_overlaps() {
    XCTAssertFalse((0...100).overlaps(()))
    XCTAssertTrue((0...100).overlaps(...))
    XCTAssertTrue((0...100).overlaps(10<..<20))
    XCTAssertFalse((0...100).overlaps(100<..<200))
  }
  
  func test_concatenation() {
    XCTAssertNil((0..<100).concatenating(100<..200))
    XCTAssertTrue((0..<100).concatenating(100..<200) == 0..<200)
    XCTAssertTrue((...400).concatenating(100..<200) == ...400)
    XCTAssertTrue((0<..<10).concatenating(()) == 0<..<10)
    XCTAssertTrue((...400).concatenating(100...) == (...))
  }
  
  func test_subtraction() {
    var subtracted = (0...100).subtracting(20...80)
    XCTAssertTrue(subtracted.0 == 0..<20)
    XCTAssertTrue(subtracted.1 == 80<..100)
    
    subtracted = TangibleUnboundedRange<Int>().subtracting(20<..<80)
    XCTAssertTrue(subtracted.0 == ...20)
    XCTAssertTrue(subtracted.1 == 80...)
    
    subtracted = (10<..<20).subtracting(11...19)
    XCTAssertTrue(subtracted.0 == .empty)
    XCTAssertNil(subtracted.1)
    
    subtracted = (..<20).subtracting(35...55)
    XCTAssertTrue(subtracted.0 == ..<20)
    XCTAssertNil(subtracted.1)
    
    subtracted = (10<..<20).subtracting(0..<11)
    XCTAssertTrue(subtracted.0 == 11..<20)
    XCTAssertNil(subtracted.1)
  }
}
#endif
