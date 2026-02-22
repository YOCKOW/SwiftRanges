/* *************************************************************************************************
 MemoizableMultipleRangesTests.swift
   © 2020,2023-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Testing
@testable import Ranges

@Suite struct MemoizablesTests {
  @Test func ranges() {
    let normalRanges = MultipleRanges<Int>([0...<10, 100...<1000])
    let ranges = MemoizableMultipleRanges<Int>(normalRanges)
    #expect(ranges.contains(5))
    #expect(ranges.contains(555))
    #expect(!ranges.contains(5555))
    #expect(ranges.contains(5)) // again
    #expect(ranges.contains(7)) // near
  }

  @Test func dictionary() {
    let normalDictionary: RangeDictionary<Int, String> = [
      0...<10: "0",
      10...<20: "10",
      20...<30: "20",
    ]
    let dictionary = MemoizableRangeDictionary(normalDictionary)
    #expect(dictionary[5] == "0")
    #expect(dictionary[15] == "10")
    #expect(dictionary[25] == "20")
    #expect(dictionary[10000] == nil)
    #expect(dictionary[5] == "0") // again
    #expect(dictionary[7] == "0") // near
  }

  @Test func concurrency() async {
    var normalRanges = MultipleRanges<Int>()
    for ii in 0..<1000 {
      normalRanges.insert((ii * 10)..<(ii * 10 + 5))
    }
    let ranges = MemoizableMultipleRanges<Int>(normalRanges)

    await withTaskGroup(of: Void.self) { group in
      for _ in 0..<1000 {
        group.addTask {
          let value = Int.random(in: 0..<(1000 * 10))
          if value % 10 < 5 {
            #expect(ranges.contains(value), "\(value) must be contained.")
          } else {
            #expect(!ranges.contains(value), "\(value) must not be contained.")
          }
        }
      }
    }
  }
}
