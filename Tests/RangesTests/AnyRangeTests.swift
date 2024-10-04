/***************************************************************************************************
 AnyRangeTests.swift
   © 2018-2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

func _forceUncountableRange<R,B>(_ range: R) -> AnyRange<B> where R: GeneralizedRange, R.Bound == B {
  return AnyRange<B>(range)
}

#if swift(>=6) && canImport(Testing)
import Testing

@Suite("AnyRange Tests")
struct AnyRangeTests {
  @Test func operators() {
    #expect(0....10 == .init(0...10))
    #expect(0<...10 == .init(0<..10))
    #expect(0<...<10 == .init(0<..<10))
    #expect(0.... == .init(0...))
    #expect(0<... == .init(0<..))
    #expect(....10 == .init(...10))
    #expect(...<10 == .init(..<10))
    #expect(0...<10 == .init(0..<10))
  }

  @Test func asRangeExpression() {
    // Default implementation is in "GeneralizedRange"

    let range1: AnyRange<Int> = 0...<1
    #expect(range1.contains(0))
    #expect(!range1.contains(1))

    let range2: AnyRange<Int> = 0<...<1
    #expect(range2.isEmpty)
    #expect(!range2.contains(0))
    let range2_1: AnyRange<Double> = 0<...<1
    #expect(!range2_1.isEmpty)
    #expect(range2_1.contains(0.5))

    let range3: AnyRange<Int> = 1<...
    #expect(range3.relative(to:[0,1,2,3]) == 2..<4)

    let range4: AnyRange<Int> = 100....100
    #expect(range4.contains(100))
    #expect(!range4.contains(1000))
  }

  @Test func concatenation() {
    #expect((0....10).concatenating(_forceUncountableRange(11...20)) == (0....20))
    #expect(_forceUncountableRange(0...10).concatenating(20....30) == nil)
    #expect(_forceUncountableRange(10...20).concatenating(0....30) == (0....30))
  }

  @Test func intersection() {
    #expect((0...<10).intersection(_forceUncountableRange(9<..20)) == .empty)
    #expect(_forceUncountableRange(0..<10).intersection(5<...20) == (5<...<10))
    #expect(_forceUncountableRange(0..<10).intersection(.unbounded) == (0...<10))
  }

  @Test func subtraction() {
    var result: (AnyRange<Int>, AnyRange<Int>?)

    result = (0<...<10).subtracting(_forceUncountableRange(1...9))
    #expect(result.0 == .empty)
    #expect(result.1 == nil)

    result = _forceUncountableRange(0..<10).subtracting(1....9)
    #expect(result.0 == (0...<1))
    #expect(result.1 == nil)

    result = _forceUncountableRange(0..<10).subtracting(1<...<9)
    #expect(result.0 == (0....1))
    #expect(result.1 == (9...<10))

    result = AnyRange<Int>(...).subtracting(10....20)
    #expect(result.0 == ...<10)
    #expect(result.1 == 20<...)
  }
}

#else
final class AnyRangeTests: XCTestCase {
  func test_operators() {
    XCTAssertEqual(0....10, .init(0...10))
    XCTAssertEqual(0<...10, .init(0<..10))
    XCTAssertEqual(0<...<10, .init(0<..<10))
    XCTAssertEqual(0...., .init(0...))
    XCTAssertEqual(0<..., .init(0<..))
    XCTAssertEqual(....10, .init(...10))
    XCTAssertEqual(...<10, .init(..<10))
    XCTAssertEqual(0...<10, .init(0..<10))
  }
  
  func test_asRangeExpression() {
    // Default implementation is in "GeneralizedRange"
    
    let range1: AnyRange<Int> = 0...<1
    XCTAssertTrue(range1.contains(0))
    XCTAssertFalse(range1.contains(1))
    
    let range2: AnyRange<Int> = 0<...<1
    XCTAssertTrue(range2.isEmpty)
    XCTAssertFalse(range2.contains(0))
    let range2_1: AnyRange<Double> = 0<...<1
    XCTAssertFalse(range2_1.isEmpty)
    XCTAssertTrue(range2_1.contains(0.5))
    
    let range3: AnyRange<Int> = 1<...
    XCTAssertEqual(range3.relative(to:[0,1,2,3]), 2..<4)
    
    let range4: AnyRange<Int> = 100....100
    XCTAssertTrue(range4.contains(100))
    XCTAssertFalse(range4.contains(1000))
  }
  
  func test_concatenation() {
    XCTAssertEqual((0....10).concatenating(_forceUncountableRange(11...20)), 0....20)
    XCTAssertEqual(_forceUncountableRange(0...10).concatenating(20....30), nil)
    XCTAssertEqual(_forceUncountableRange(10...20).concatenating(0....30), 0....30)
  }
  
  func test_intersection() {
    XCTAssertEqual((0...<10).intersection(_forceUncountableRange(9<..20)), .empty)
    XCTAssertEqual(_forceUncountableRange(0..<10).intersection(5<...20), 5<...<10)
    XCTAssertEqual(_forceUncountableRange(0..<10).intersection(.unbounded), 0...<10)
  }
  
  func test_subtraction() {
    var result: (AnyRange<Int>, AnyRange<Int>?)
    
    result = (0<...<10).subtracting(_forceUncountableRange(1...9))
    XCTAssertEqual(result.0, .empty)
    XCTAssertEqual(result.1, nil)
    
    result = _forceUncountableRange(0..<10).subtracting(1....9)
    XCTAssertEqual(result.0, 0...<1)
    XCTAssertEqual(result.1, nil)
    
    result = _forceUncountableRange(0..<10).subtracting(1<...<9)
    XCTAssertEqual(result.0, 0....1)
    XCTAssertEqual(result.1, 9...<10)
    
    result = AnyRange<Int>(...).subtracting(10....20)
    XCTAssertEqual(result.0, ...<10)
    XCTAssertEqual(result.1, 20<...)
  }
}
#endif
