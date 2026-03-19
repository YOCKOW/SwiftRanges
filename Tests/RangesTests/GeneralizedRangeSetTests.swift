/* *************************************************************************************************
 GeneralizedRangeSetTests.swift
   © 2018-2019,2024-2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Testing
@testable import Ranges

private func _expectCount<C, B>(
  _ count: Int,
  ofRanges ranges: C,
  sourceLocation: SourceLocation = #_sourceLocation
) -> Bool where C: Collection, C.Element == any GeneralizedRange<B> {
  let actualCount = ranges.count
  guard actualCount == count else {
    Issue.record(
      "Unexpected count. Expected \(count), but got \(actualCount). Ranges: \(ranges).",
      sourceLocation: sourceLocation
    )
    return false
  }
  return true
}

@Suite struct GeneralizedRangeSetTests {
  @Test func ranges() {
    let multi: GeneralizedRangeSet<Int> = [10...20, 30..., ..<0]
    let ranges = multi.ranges
    guard _expectCount(3, ofRanges: ranges) else {
      return
    }
    #expect(ranges[0].isEqual(to: ..<0))
    #expect(ranges[1].isEqual(to: 10...20))
    #expect(ranges[2].isEqual(to: 30...))
  }

  @Test func normalization() {
    let range1: PartialRangeUpTo<Int> = ..<15
    let range2: Range<Int> = 10 ..< 40
    let range3: ClosedRange<Int> = 60 ... 80
    let range4: Range<Int> = 90 ..< 100
    let range5: PartialRangeFrom<Int> = 100...

    var set = GeneralizedRangeSet<Int>()
    set.insert(range5)
    set.insert(range4)
    set.insert(range3)
    set.insert(range2)
    set.insert(range1)

    guard _expectCount(3, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<40))
    #expect(set.ranges[1].isEqual(to: 60...80))
    #expect(set.ranges[2].isEqual(to: 90...))

    #expect(set.contains(-100))
    #expect(set.contains(5))
    #expect(!set.contains(50))
    #expect(set.contains(70))
    #expect(!set.contains(85))
    #expect(set.contains(100))
    #expect(set.contains(1000))

    let range6: LeftOpenRange<Int> = 40<..50
    set.insert(range6)
    guard _expectCount(4, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<40))
    #expect(set.ranges[1].isEqual(to: 40<..50))
    #expect(set.ranges[2].isEqual(to: 60...80))
    #expect(set.ranges[3].isEqual(to: 90...))
    #expect(!set.contains(40))
    #expect(set.contains(41))

    let range7: OpenRange<Int> = 50<..<60
    set.insert(range7)
    guard _expectCount(3, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<40))
    #expect(set.ranges[1].isEqual(to: 40<..80))
    #expect(set.ranges[2].isEqual(to: 90...))
    #expect(!set.contains(40))
    #expect(set.contains(55))

    let range8: PartialRangeGreaterThan<Int> = 85<..
    set.insert(range8)
    guard _expectCount(3, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<40))
    #expect(set.ranges[1].isEqual(to: 40<..80))
    #expect(set.ranges[2].isEqual(to: 85<..))
    #expect(!set.contains(85))
    #expect(set.contains(100))
    #expect(set.contains(Int.max))
  }

  @Test func nomarlization_UInt32() {
    // https://github.com/YOCKOW/SwiftRanges/issues/20
    var set = GeneralizedRangeSet<UInt32>()
    set.insert(UInt32(0x00)...UInt32(0x1F))
    set.insert(UInt32(0x20)...UInt32(0x2F))
    set.insert(UInt32(0x40)...UInt32(0x4F))
    let ranges = set.ranges
    guard _expectCount(2, ofRanges: ranges) else {
      return
    }
    #expect(ranges[0].isEqual(to: 0x00...0x2F))
    #expect(ranges[1].isEqual(to: 0x40...0x4F))
  }

  @Test func subtraction() {
    var set: GeneralizedRangeSet<Int> = [..<20, 30<..<40, 50<..60, 70..<80, 80...]

    set.subtract(35...55)
    guard _expectCount(4, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<20))
    #expect(set.ranges[1].isEqual(to: 30<..<35))
    #expect(set.ranges[2].isEqual(to: 55<..60))
    #expect(set.ranges[3].isEqual(to: 70...))

    set.subtract(singleValue: 90)
    guard _expectCount(5, ofRanges: set.ranges) else {
      return
    }
    #expect(set.ranges[0].isEqual(to: ..<20))
    #expect(set.ranges[1].isEqual(to: 30<..<35))
    #expect(set.ranges[2].isEqual(to: 55<..60))
    #expect(set.ranges[3].isEqual(to: 70..<90))
    #expect(set.ranges[4].isEqual(to: 90<..))

    let set2: GeneralizedRangeSet<Int> = [...10, 80<..]

    let set3 = set.subtracting(set2)

    #expect(set == set)
    #expect(set != set3)
    guard _expectCount(4, ofRanges: set3.ranges) else {
      return
    }
    #expect(set3.ranges[0].isEqual(to: 10<..<20))
    #expect(set3.ranges[1].isEqual(to: 30<..<35))
    #expect(set3.ranges[2].isEqual(to: 55<..60))
    #expect(set3.ranges[3].isEqual(to: 70...80))

    #expect(set3.union(set2).subtracting(90...90) == set)
  }

  @Test func intersection() {
    let set1: GeneralizedRangeSet<Int> = [..<20, 30<..<40, 50<..60, 70..<80, 80...]
    let set2: GeneralizedRangeSet<Int> = [15...55, 60<..79, 90<..]

    let intersections = set1.intersection(set2).ranges
    guard _expectCount(5, ofRanges: intersections) else {
      return
    }
    #expect(intersections[0].isEqual(to: 15..<20))
    #expect(intersections[1].isEqual(to: 30<..<40))
    #expect(intersections[2].isEqual(to: 50<..55))
    #expect(intersections[3].isEqual(to: 70...79))
    #expect(intersections[4].isEqual(to: 90<..))
  }

  @Test func countableIntersection() {
    let set1: GeneralizedRangeSet<Int> = [..<10]
    let set2: GeneralizedRangeSet<Int> = [9<..]
    #expect(set1.intersection(set2).isEmpty)
  }
}
