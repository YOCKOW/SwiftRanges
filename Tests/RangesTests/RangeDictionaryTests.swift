/* *************************************************************************************************
 RangeDictionaryTests.swift
   © 2019,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Testing
@testable import Ranges

@Suite struct RangeDictionaryTests {
  let simpleDictionary: RangeDictionary<Int, String> = [
        0 ...<    10: "A",
      100 ...<   110: "B",
     1000 ...<  1010: "C",
    10000 ...< 10010: "D"
  ]

  @Test func normalizationInInit() {
    let dic = RangeDictionary<Int, String>([
      (0....9, "A"),
      (10....19, "A"),
      (20....29, "B"),
    ])
    #expect(dic.count == 2)
  }

  @Test func subscriptTest() {
    #expect(simpleDictionary[0] == "A")
    #expect(simpleDictionary[105] == "B")
    #expect(simpleDictionary[1006] == "C")
    #expect(simpleDictionary[10007] == "D")
    #expect(simpleDictionary[-1] == nil)
    #expect(simpleDictionary[10] == nil)
    #expect(simpleDictionary[999] == nil)
    #expect(simpleDictionary[Int.max] == nil)
  }

  @Test func removal() {
    var dic = simpleDictionary
    dic.remove(range: 5<...<10005)
    #expect(dic[5] == "A")
    #expect(dic[6] == nil)
    #expect(dic[105] == nil)
    #expect(dic[1005] == nil)
    #expect(dic[10004] == nil)
    #expect(dic[10005] == "D")

    dic = simpleDictionary
    dic.remove(range: 105....200)
    #expect(dic[5] == "A")
    #expect(dic[100] == "B")
    #expect(dic[105] == nil)
    #expect(dic[1000] == "C")
    #expect(dic[10000] == "D")

    dic = simpleDictionary
    dic.remove(range: 90....105)
    #expect(dic[5] == "A")
    #expect(dic[100] == nil)
    #expect(dic[105] == nil)
    #expect(dic[109] == "B")
    #expect(dic[1000] == "C")
    #expect(dic[10000] == "D")

    dic = simpleDictionary
    dic.remove(range: .init(singleValue: 105))
    #expect(dic[5] == "A")
    #expect(dic[100] == "B")
    #expect(dic[105] == nil)
    #expect(dic[109] == "B")
    #expect(dic[1000] == "C")
    #expect(dic[10000] == "D")
  }

  @Test func insertion() {
    var dic = simpleDictionary
    dic.insert("NEW", forRange: Int.min....Int.max)
    #expect(dic[Int.random(in: Int.min...Int.max)] == "NEW")

    dic = simpleDictionary
    dic.insert("NEW", forRange: 5<...<10005)
    #expect(dic[3] == "A")
    #expect(dic[100] == "NEW")
    #expect(dic[555] == "NEW")
    #expect(dic[10008] == "D")

    do {
      // For checking MultipleRanges' normalization
      let range1: PartialRangeUpTo<Int> = ..<15
      let range2: Range<Int> = 10 ..< 40
      let range3: ClosedRange<Int> = 60 ... 80
      let range4: Range<Int> = 90 ..< 100
      let range5: PartialRangeFrom<Int> = 100...

      var dic = RangeDictionary<Int, Int>()
      dic.insert(0, forRange: .init(range5))
      dic.insert(0, forRange: .init(range4))
      dic.insert(0, forRange: .init(range3))
      dic.insert(0, forRange: .init(range2))
      dic.insert(0, forRange: .init(range1))

      #expect(dic[dic.startIndex].0 == ...<40)
      #expect(dic[dic.index(after: dic.startIndex)].0 == (60....80))
      #expect(dic.last?.0 == 90....)
    }
  }

  @Test func asCollection() {
    let array: [RangeDictionary<Int, String>.Element] = .init(simpleDictionary)
    #expect(array[0] == (0...<10, "A"))
    #expect(array[1] == (100...<110, "B"))
    #expect(array[2] == (1000...<1010, "C"))
    #expect(array[3] == (10000...<10010, "D"))
  }

  @Test func limit() {
    let limited = simpleDictionary.limited(within: 5<...10005)
    #expect(limited[0] == nil)
    #expect(limited[5] == nil)
    #expect(limited[7] == "A")
    #expect(limited[105] == "B")
    #expect(limited[1005] == "C")
    #expect(limited[10005] == "D")
    #expect(limited[10007] == nil)
  }
}
