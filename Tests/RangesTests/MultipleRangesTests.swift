/***************************************************************************************************
 MultipleRangesTests.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class MultipleRangesTests: XCTestCase {
  func test_ranges() {
    let multi: MultipleRanges<Int> = [.init(10...20), .init(30...), .init(..<0)]
    let ranges = multi.ranges
    XCTAssertEqual(ranges.count, 3)
    XCTAssertEqual(ranges[0], .init(..<0))
    XCTAssertEqual(ranges[1], .init(10...20))
    XCTAssertEqual(ranges[2], .init(30...))
  }
  
  func test_normalization() {
    let range1: PartialRangeUpTo<Int> = ..<15
    let range2: Range<Int> = 10 ..< 40
    let range3: ClosedRange<Int> = 60 ... 80
    let range4: Range<Int> = 90 ..< 100
    let range5: PartialRangeFrom<Int> = 100...
    
    var multi = MultipleRanges<Int>()
    multi.insert(range5)
    multi.insert(range4)
    multi.insert(range3)
    multi.insert(range2)
    multi.insert(range1)
    
    XCTAssertEqual(multi.ranges.count, 3)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<40))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(60...80))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(90...))
    
    XCTAssertTrue(multi.contains(-100))
    XCTAssertTrue(multi.contains(5))
    XCTAssertFalse(multi.contains(50))
    XCTAssertTrue(multi.contains(70))
    XCTAssertFalse(multi.contains(85))
    XCTAssertTrue(multi.contains(100))
    XCTAssertTrue(multi.contains(1000))
    
    let range6: LeftOpenRange<Int> = 40<..50
    multi.insert(range6)
    XCTAssertEqual(multi.ranges.count, 4)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<40))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(40<..50))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(60...80))
    XCTAssertEqual(multi.ranges[3], AnyRange<Int>(90...))
    XCTAssertFalse(multi.contains(40))
    XCTAssertTrue(multi.contains(41))
    
    let range7: OpenRange<Int> = 50<..<60
    multi.insert(range7)
    XCTAssertEqual(multi.ranges.count, 3)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<40))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(40<..80))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(90...))
    XCTAssertFalse(multi.contains(40))
    XCTAssertTrue(multi.contains(55))
    
    let range8: PartialRangeGreaterThan<Int> = 85<..
    multi.insert(range8)
    XCTAssertEqual(multi.ranges.count, 3)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<40))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(40<..80))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(85<..))
    XCTAssertFalse(multi.contains(85))
    XCTAssertTrue(multi.contains(100))
    XCTAssertTrue(multi.contains(Int.max))
  }
  
  func test_subtraction() {
    var multi: MultipleRanges<Int> = [
      AnyRange<Int>(..<20),
      AnyRange<Int>(30<..<40),
      AnyRange<Int>(50<..60),
      AnyRange<Int>(70..<80),
      AnyRange<Int>(80...)
    ]
    
    multi.subtract(AnyRange<Int>(35...55))
    XCTAssertEqual(multi.ranges.count, 4)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<20))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(30<..<35))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(55<..60))
    XCTAssertEqual(multi.ranges[3], AnyRange<Int>(70...))

    multi.subtract(AnyRange<Int>(singleValue:90))
    XCTAssertEqual(multi.ranges.count, 5)
    XCTAssertEqual(multi.ranges[0], AnyRange<Int>(..<20))
    XCTAssertEqual(multi.ranges[1], AnyRange<Int>(30<..<35))
    XCTAssertEqual(multi.ranges[2], AnyRange<Int>(55<..60))
    XCTAssertEqual(multi.ranges[3], AnyRange<Int>(70..<90))
    XCTAssertEqual(multi.ranges[4], AnyRange<Int>(90<..))

    let multi2: MultipleRanges<Int> = [
      AnyRange<Int>(...10),
      AnyRange<Int>(80<..)
    ]

    let multi3 = multi.subtracting(multi2)

    XCTAssertEqual(multi, multi)
    XCTAssertNotEqual(multi, multi3)
    XCTAssertEqual(multi3.ranges.count, 4)
    XCTAssertEqual(multi3.ranges[0], AnyRange<Int>(10<..<20))
    XCTAssertEqual(multi3.ranges[1], AnyRange<Int>(30<..<35))
    XCTAssertEqual(multi3.ranges[2], AnyRange<Int>(55<..60))
    XCTAssertEqual(multi3.ranges[3], AnyRange<Int>(70...80))

    XCTAssertEqual(multi3.union(multi2).subtracting(AnyRange<Int>(singleValue:90)), multi)
  }
  
  func test_intersection() {
    let multi1: MultipleRanges<Int> = [
      AnyRange<Int>(..<20),
      AnyRange<Int>(30<..<40),
      AnyRange<Int>(50<..60),
      AnyRange<Int>(70..<80),
      AnyRange<Int>(80...)
    ]
    let multi2: MultipleRanges<Int> = [
      AnyRange<Int>(15...55),
      AnyRange<Int>(60<..79),
      AnyRange<Int>(90<..)
    ]
    
    let intersections = multi1.intersection(multi2).ranges
    XCTAssertEqual(intersections.count, 5)
    XCTAssertTrue(intersections[0] == 15..<20)
    XCTAssertTrue(intersections[1] == 30<..<40)
    XCTAssertTrue(intersections[2] == 50<..55)
    XCTAssertTrue(intersections[3] == 70...79)
    XCTAssertTrue(intersections[4] == 90<..)
  }
  
  func test_countableIntersection() {
    let multi1: MultipleRanges<Int> = [AnyRange<Int>(..<10)]
    let multi2: MultipleRanges<Int> = [AnyRange<Int>(9<..)]
    XCTAssertTrue(multi1.intersection(multi2).isEmpty)
  }
}

