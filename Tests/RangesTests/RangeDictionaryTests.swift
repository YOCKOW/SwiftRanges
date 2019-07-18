/* *************************************************************************************************
 RangeDictionaryTests.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import Ranges

final class RangeDictionaryTests: XCTestCase {
  let simpleDictionary: RangeDictionary<Int, String> = [
        0 ...<    10: "A",
      100 ...<   110: "B",
     1000 ...<  1010: "C",
    10000 ...< 10010: "D"
  ]
  
  func test_subscript() {
    XCTAssertEqual(simpleDictionary[0], "A")
    XCTAssertEqual(simpleDictionary[105], "B")
    XCTAssertEqual(simpleDictionary[1006], "C")
    XCTAssertEqual(simpleDictionary[10007], "D")
    XCTAssertNil(simpleDictionary[-1])
    XCTAssertNil(simpleDictionary[10])
    XCTAssertNil(simpleDictionary[999])
    XCTAssertNil(simpleDictionary[Int.max])
  }

  func test_removal() {
    var dic = simpleDictionary
    dic.remove(range: 5<...<10005)
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[6], nil)
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[1005], nil)
    XCTAssertEqual(dic[10004], nil)
    XCTAssertEqual(dic[10005], "D")
    
    dic = simpleDictionary
    dic.remove(range: 105....200)
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[100], "B")
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[1000], "C")
    XCTAssertEqual(dic[10000], "D")
    
    dic = simpleDictionary
    dic.remove(range: 90....105)
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[100], nil)
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[109], "B")
    XCTAssertEqual(dic[1000], "C")
    XCTAssertEqual(dic[10000], "D")
    
    dic = simpleDictionary
    dic.remove(range: .init(singleValue: 105))
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[100], "B")
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[109], "B")
    XCTAssertEqual(dic[1000], "C")
    XCTAssertEqual(dic[10000], "D")
  }
  
  func test_insertion() {
    var dic = simpleDictionary
    dic.insert("NEW", forRange: Int.min....Int.max)
    XCTAssertEqual(dic[Int.random(in: Int.min...Int.max)], "NEW")
    
    dic = simpleDictionary
    dic.insert("NEW", forRange: 5<...<10005)
    XCTAssertEqual(dic[3], "A")
    XCTAssertEqual(dic[100], "NEW")
    XCTAssertEqual(dic[555], "NEW")
    XCTAssertEqual(dic[10008], "D")
    
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
      
      XCTAssertEqual(dic[dic.startIndex].0, ...<40)
      XCTAssertEqual(dic[dic.index(after: dic.startIndex)].0, 60....80)
      XCTAssertEqual(dic.last?.0, 90....)
    }
  }
  
  func test_asCollection() {
    let array: [RangeDictionary<Int, String>.Element] = .init(simpleDictionary)
    XCTAssertTrue(array[0] == (0...<10, "A"))
    XCTAssertTrue(array[1] == (100...<110, "B"))
    XCTAssertTrue(array[2] == (1000...<1010, "C"))
    XCTAssertTrue(array[3] == (10000...<10010, "D"))
  }
  
  func test_limit() {
    let limited = simpleDictionary.limited(within: 5<...10005)
    XCTAssertEqual(limited[0], nil)
    XCTAssertEqual(limited[5], nil)
    XCTAssertEqual(limited[7], "A")
    XCTAssertEqual(limited[105], "B")
    XCTAssertEqual(limited[1005], "C")
    XCTAssertEqual(limited[10005], "D")
    XCTAssertEqual(limited[10007], nil)
  }
}



