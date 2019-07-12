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
    .init(0..<10): "A",
    .init(100..<110): "B",
    .init(1000..<1010): "C",
    .init(10000..<10010): "D"
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
    dic.remove(range: .init(5<..<10005))
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[6], nil)
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[1005], nil)
    XCTAssertEqual(dic[10004], nil)
    XCTAssertEqual(dic[10005], "D")
    
    dic = simpleDictionary
    dic.remove(range: .init(105...200))
    XCTAssertEqual(dic[5], "A")
    XCTAssertEqual(dic[100], "B")
    XCTAssertEqual(dic[105], nil)
    XCTAssertEqual(dic[1000], "C")
    XCTAssertEqual(dic[10000], "D")
    
    dic = simpleDictionary
    dic.remove(range: .init(90...105))
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
    dic.insert("NEW", forRange: .init(Int.min...Int.max))
    XCTAssertEqual(dic[Int.random(in: Int.min...Int.max)], "NEW")
    
    dic = simpleDictionary
    dic.insert("NEW", forRange: .init(5<..<10005))
    XCTAssertEqual(dic[3], "A")
    XCTAssertEqual(dic[100], "NEW")
    XCTAssertEqual(dic[555], "NEW")
    XCTAssertEqual(dic[10008], "D")
  }
}



