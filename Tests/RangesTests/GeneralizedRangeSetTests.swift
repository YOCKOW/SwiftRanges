/* *************************************************************************************************
 GeneralizedRangeSetTests.swift
   © 2018-2019,2024-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Testing
@testable import Ranges

@Suite struct MultipleRangesTests {
  @Test func ranges() {
    let multi: GeneralizedRangeSet<Int> = [10....20, 30...., ...<0]
    let ranges = multi.ranges
    #expect(ranges.count == 3)
    #expect(ranges[0] == .init(..<0))
    #expect(ranges[1] == .init(10...20))
    #expect(ranges[2] == .init(30...))
  }

  @Test func normalization() {
    let range1: PartialRangeUpTo<Int> = ..<15
    let range2: Range<Int> = 10 ..< 40
    let range3: ClosedRange<Int> = 60 ... 80
    let range4: Range<Int> = 90 ..< 100
    let range5: PartialRangeFrom<Int> = 100...

    var multi = GeneralizedRangeSet<Int>()
    multi.insert(range5)
    multi.insert(range4)
    multi.insert(range3)
    multi.insert(range2)
    multi.insert(range1)

    #expect(multi.ranges.count == 3)
    #expect(multi.ranges[0] == ...<40)
    #expect(multi.ranges[1] == (60....80))
    #expect(multi.ranges[2] == 90....)

    #expect(multi.contains(-100))
    #expect(multi.contains(5))
    #expect(!multi.contains(50))
    #expect(multi.contains(70))
    #expect(!multi.contains(85))
    #expect(multi.contains(100))
    #expect(multi.contains(1000))

    let range6: LeftOpenRange<Int> = 40<..50
    multi.insert(range6)
    #expect(multi.ranges.count == 4)
    #expect(multi.ranges[0] == ...<40)
    #expect(multi.ranges[1] == 40<...50)
    #expect(multi.ranges[2] == (60....80))
    #expect(multi.ranges[3] == 90....)
    #expect(!multi.contains(40))
    #expect(multi.contains(41))

    let range7: OpenRange<Int> = 50<..<60
    multi.insert(range7)
    #expect(multi.ranges.count == 3)
    #expect(multi.ranges[0] == ...<40)
    #expect(multi.ranges[1] == 40<...80)
    #expect(multi.ranges[2] == 90....)
    #expect(!multi.contains(40))
    #expect(multi.contains(55))

    let range8: PartialRangeGreaterThan<Int> = 85<..
    multi.insert(range8)
    #expect(multi.ranges.count == 3)
    #expect(multi.ranges[0] == ...<40)
    #expect(multi.ranges[1] == 40<...80)
    #expect(multi.ranges[2] == 85<...)
    #expect(!multi.contains(85))
    #expect(multi.contains(100))
    #expect(multi.contains(Int.max))
  }

  @Test func nomarlization_UInt32() {
    // https://github.com/YOCKOW/SwiftRanges/issues/20
    var multi = GeneralizedRangeSet<UInt32>()
    multi.insert(UInt32(0x00)...UInt32(0x1F))
    multi.insert(UInt32(0x20)...UInt32(0x2F))
    multi.insert(UInt32(0x40)...UInt32(0x4F))
    let ranges = multi.ranges
    #expect(ranges == [0x00....0x2F, 0x40....0x4F])
  }

  @Test func subtraction() {
    var multi: GeneralizedRangeSet<Int> = [...<20, 30<...<40, 50<...60, 70...<80, 80....]

    multi.subtract(35....55)
    #expect(multi.ranges.count == 4)
    #expect(multi.ranges[0] == ...<20)
    #expect(multi.ranges[1] == (30<...<35))
    #expect(multi.ranges[2] == 55<...60)
    #expect(multi.ranges[3] == 70....)

    multi.subtract(AnyRange<Int>(singleValue:90))
    #expect(multi.ranges.count == 5)
    #expect(multi.ranges[0] == ...<20)
    #expect(multi.ranges[1] == (30<...<35))
    #expect(multi.ranges[2] == (55<...60))
    #expect(multi.ranges[3] == (70...<90))
    #expect(multi.ranges[4] == (90<...))

    let multi2: GeneralizedRangeSet<Int> = [....10, 80<...]

    let multi3 = multi.subtracting(multi2)

    #expect(multi == multi)
    #expect(multi != multi3)
    #expect(multi3.ranges.count == 4)
    #expect(multi3.ranges[0] == (10<...<20))
    #expect(multi3.ranges[1] == (30<...<35))
    #expect(multi3.ranges[2] == (55<...60))
    #expect(multi3.ranges[3] == (70....80))

    #expect(multi3.union(multi2).subtracting(AnyRange<Int>(singleValue:90)) == multi)
  }

  @Test func intersection() {
    let multi1: GeneralizedRangeSet<Int> = [...<20, 30<...<40, 50<...60, 70...<80, 80....]
    let multi2: GeneralizedRangeSet<Int> = [15....55, 60<...79, 90<...]

    let intersections = multi1.intersection(multi2).ranges
    guard intersections.count == 5 else {
      Issue.record("Unexpected ranges: \(intersections)")
      return
    }
    #expect(intersections[0] == (15...<20))
    #expect(intersections[1] == (30<...<40))
    #expect(intersections[2] == (50<...55))
    #expect(intersections[3] == (70....79))
    #expect(intersections[4] == (90<...))
  }

  @Test func countableIntersection() {
    let multi1: GeneralizedRangeSet<Int> = [...<10]
    let multi2: GeneralizedRangeSet<Int> = [9<...]
    #expect(multi1.intersection(multi2).isEmpty)
  }
}
