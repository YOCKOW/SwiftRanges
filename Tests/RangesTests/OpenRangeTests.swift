/***************************************************************************************************
 OpenRangeTests.swift
   © 2018-2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct OpenRangeTests {
  @Test func asRangeExpression() {
    let openRange: OpenRange<Int> =  0<..<5 // cannot be "0 <..<5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]

    #expect(!openRange.contains(0))
    #expect(openRange.contains(3))
    #expect(!openRange.contains(5))

    let rel = openRange.relative(to:array)
    #expect(rel == rel.relative(to:array))
  }

  @Test func asGeneralizedRange() throws {
    let bounds = try #require((0<..<5).bounds)

    #expect(bounds.lower == .excluded(0))
    #expect(bounds.upper == .excluded(5))
  }

  @Test func emptiness() {
    #expect(CountableOpenRange(uncheckedBounds:(lower:10, upper:10)).isEmpty)
    #expect(CountableOpenRange(uncheckedBounds:(lower:10, upper:11)).isEmpty) // empty!!
    #expect(!CountableOpenRange(uncheckedBounds:(lower:10, upper:12)).isEmpty)

    #expect(OpenRange(uncheckedBounds:(lower:1.0, upper:1.0)).isEmpty)
    #expect(!OpenRange(uncheckedBounds:(lower:1.0, upper:1.1)).isEmpty)
    #expect(!OpenRange(uncheckedBounds:(lower:1.0, upper:1.2)).isEmpty)
  }
}
#else
final class OpenRangeTests: XCTestCase {
  func test_asRangeExpression() {
    let openRange: OpenRange<Int> =  0<..<5 // cannot be "0 <..<5"
    let array = [0,1,2,3,4,5,6,7,8,9,10]
    
    XCTAssertFalse(openRange.contains(0))
    XCTAssertTrue(openRange.contains(3))
    XCTAssertFalse(openRange.contains(5))
    
    let rel = openRange.relative(to:array)
    XCTAssertEqual(rel, rel.relative(to:array))
  }
  
  func test_asGeneralizedRange() {
    let bounds = (0<..<5).bounds
    
    XCTAssertNotNil(bounds)
    XCTAssertEqual(bounds?.lower, .excluded(0))
    XCTAssertEqual(bounds?.upper, .excluded(5))
  }
  
  func test_emptiness() {
    XCTAssertTrue(CountableOpenRange(uncheckedBounds:(lower:10, upper:10)).isEmpty)
    XCTAssertTrue(CountableOpenRange(uncheckedBounds:(lower:10, upper:11)).isEmpty) // empty!!
    XCTAssertFalse(CountableOpenRange(uncheckedBounds:(lower:10, upper:12)).isEmpty)
    
    XCTAssertTrue(OpenRange(uncheckedBounds:(lower:1.0, upper:1.0)).isEmpty)
    XCTAssertFalse(OpenRange(uncheckedBounds:(lower:1.0, upper:1.1)).isEmpty)
    XCTAssertFalse(OpenRange(uncheckedBounds:(lower:1.0, upper:1.2)).isEmpty)
  }
}
#endif
