/***************************************************************************************************
 OverlapTests.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/
 
import XCTest
@testable import Ranges

final class OverlapTests: XCTestCase {
  
  // Here are targets
  let leftOpenRange_Int: LeftOpenRange<Int> = 20<..40
  let leftOpenRange_Double: LeftOpenRange<Double> = 2.0<..4.0
  let openRange_Int: OpenRange<Int> = 20<.<40
  let openRange_Double: OpenRange<Double> = 2.0<.<4.0
  let partialRangeGreaterThan_Int: PartialRangeGreaterThan<Int> = 20<..
  let partialRangeGreaterThan_Double: PartialRangeGreaterThan<Double> = 2.0<..
  
  func test_LeftOpenRange_ClosedRange_Int() {
    let cases:[(ClosedRange<Int>, Bool)] = [
      (10...15, false),
      (10...20, false),
      (10...21, true),
      (10...30, true),
      (10...39, true),
      (10...40, true),
      (10...41, true),
      (10...50, true),
      
      (19...20, false),
      (19...21, true),
      (19...30, true),
      (19...39, true),
      (19...40, true),
      (19...41, true),
      (19...50, true),
      
      (20...20, false),
      (20...21, true),
      (20...30, true),
      (20...39, true),
      (20...40, true),
      (20...41, true),
      (20...50, true),
      
      (30...30, true),
      (30...39, true),
      (30...40, true),
      (30...41, true),
      (30...50, true),
      
      (39...39, true),
      (39...40, true),
      (39...41, true),
      (39...50, true),
      
      (40...40, true),
      (40...41, true),
      (40...50, true),
      
      (41...41, false),
      (41...50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_ClosedRange_Double() {
    let cases:[(ClosedRange<Double>, Bool)] = [
      (1.0...1.5, false),
      (1.0...2.0, false),
      (1.0...2.1, true),
      (1.0...3.0, true),
      (1.0...3.9, true),
      (1.0...4.0, true),
      (1.0...4.1, true),
      (1.0...5.0, true),
      
      (1.9...2.0, false),
      (1.9...2.1, true),
      (1.9...3.0, true),
      (1.9...3.9, true),
      (1.9...4.0, true),
      (1.9...4.1, true),
      (1.9...5.0, true),
      
      (2.0...2.0, false),
      (2.0...2.1, true),
      (2.0...3.0, true),
      (2.0...3.9, true),
      (2.0...4.0, true),
      (2.0...4.1, true),
      (2.0...5.0, true),
      
      (3.0...3.0, true),
      (3.0...3.9, true),
      (3.0...4.0, true),
      (3.0...4.1, true),
      (3.0...5.0, true),
      
      (3.9...3.9, true),
      (3.9...4.0, true),
      (3.9...4.1, true),
      (3.9...5.0, true),
      
      (4.0...4.0, true),
      (4.0...4.1, true),
      (4.0...5.0, true),
      
      (4.1...4.1, false),
      (4.1...5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_LeftOpenRange_Int() {
    let cases:[(LeftOpenRange<Int>, Bool)] = [
      (10<..15, false),
      (10<..20, false),
      (10<..21, true),
      (10<..30, true),
      (10<..39, true),
      (10<..40, true),
      (10<..41, true),
      (10<..50, true),
      
      (19<..20, false),
      (19<..21, true),
      (19<..30, true),
      (19<..39, true),
      (19<..40, true),
      (19<..41, true),
      (19<..50, true),
      
      (20<..20, false),
      (20<..21, true),
      (20<..30, true),
      (20<..39, true),
      (20<..40, true),
      (20<..41, true),
      (20<..50, true),
      
      (30<..30, false),
      (30<..39, true),
      (30<..40, true),
      (30<..41, true),
      (30<..50, true),
      
      (39<..39, false),
      (39<..40, true),
      (39<..41, true),
      (39<..50, true),
      
      (40<..40, false),
      (40<..41, false),
      (40<..50, false),
      
      (41<..41, false),
      (41<..50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_LeftOpenRange_Double() {
    let cases:[(LeftOpenRange<Double>, Bool)] = [
      (1.0<..1.5, false),
      (1.0<..2.0, false),
      (1.0<..2.1, true),
      (1.0<..3.0, true),
      (1.0<..3.9, true),
      (1.0<..4.0, true),
      (1.0<..4.1, true),
      (1.0<..5.0, true),
      
      (1.9<..2.0, false),
      (1.9<..2.1, true),
      (1.9<..3.0, true),
      (1.9<..3.9, true),
      (1.9<..4.0, true),
      (1.9<..4.1, true),
      (1.9<..5.0, true),
      
      (2.0<..2.0, false),
      (2.0<..2.1, true),
      (2.0<..3.0, true),
      (2.0<..3.9, true),
      (2.0<..4.0, true),
      (2.0<..4.1, true),
      (2.0<..5.0, true),
      
      (3.0<..3.0, false),
      (3.0<..3.9, true),
      (3.0<..4.0, true),
      (3.0<..4.1, true),
      (3.0<..5.0, true),
      
      (3.9<..3.9, false),
      (3.9<..4.0, true),
      (3.9<..4.1, true),
      (3.9<..5.0, true),
      
      (4.0<..4.0, false),
      (4.0<..4.1, false),
      (4.0<..5.0, false),
      
      (4.1<..4.1, false),
      (4.1<..5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_PartialRangeFrom_Int() {
    let cases:[(PartialRangeFrom<Int>, Bool)] = [
      (10..., true),
      (19..., true),
      (20..., true),
      (30..., true),
      (39..., true),
      (40..., true),
      (41..., false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_PartialRangeFrom_Double() {
    let cases:[(PartialRangeFrom<Double>, Bool)] = [
      (1.0..., true),
      (1.9..., true),
      (2.0..., true),
      (3.0..., true),
      (3.9..., true),
      (4.0..., true),
      (4.1..., false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_PartialRangeGreaterThan_Int() {
    let cases:[(PartialRangeGreaterThan<Int>, Bool)] = [
      (10<.., true),
      (19<.., true),
      (20<.., true),
      (30<.., true),
      (39<.., true),
      (40<.., false),
      (41<.., false),
      ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_PartialRangeGreaterThan_Double() {
    let cases:[(PartialRangeGreaterThan<Double>, Bool)] = [
      (1.0<.., true),
      (1.9<.., true),
      (2.0<.., true),
      (3.0<.., true),
      (3.9<.., true),
      (4.0<.., false),
      (4.1<.., false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_OpenRange_Int() {
    let cases:[(OpenRange<Int>, Bool)] = [
      (10<.<15, false),
      (10<.<20, false),
      (10<.<21, false),
      (10<.<30, true),
      (10<.<39, true),
      (10<.<40, true),
      (10<.<41, true),
      (10<.<50, true),
      
      (19<.<20, false),
      (19<.<21, false),
      (19<.<30, true),
      (19<.<39, true),
      (19<.<40, true),
      (19<.<41, true),
      (19<.<50, true),
      
      (20<.<20, false),
      (20<.<21, false),
      (20<.<30, true),
      (20<.<39, true),
      (20<.<40, true),
      (20<.<41, true),
      (20<.<50, true),
      
      (30<.<30, false),
      (30<.<39, true),
      (30<.<40, true),
      (30<.<41, true),
      (30<.<50, true),
      
      (39<.<39, false),
      (39<.<40, false),
      (39<.<41, true),
      (39<.<50, true),
      
      (40<.<40, false),
      (40<.<41, false),
      (40<.<50, false),
      
      (41<.<41, false),
      (41<.<50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_OpenRange_Double() {
    let cases:[(OpenRange<Double>, Bool)] = [
      (1.0<.<1.5, false),
      (1.0<.<2.0, false),
      (1.0<.<2.1, true),
      (1.0<.<3.0, true),
      (1.0<.<3.9, true),
      (1.0<.<4.0, true),
      (1.0<.<4.1, true),
      (1.0<.<5.0, true),
      
      (1.9<.<2.0, false),
      (1.9<.<2.1, true),
      (1.9<.<3.0, true),
      (1.9<.<3.9, true),
      (1.9<.<4.0, true),
      (1.9<.<4.1, true),
      (1.9<.<5.0, true),
      
      (2.0<.<2.0, false),
      (2.0<.<2.1, true),
      (2.0<.<3.0, true),
      (2.0<.<3.9, true),
      (2.0<.<4.0, true),
      (2.0<.<4.1, true),
      (2.0<.<5.0, true),
      
      (3.0<.<3.0, false),
      (3.0<.<3.9, true),
      (3.0<.<4.0, true),
      (3.0<.<4.1, true),
      (3.0<.<5.0, true),
      
      (3.9<.<3.9, false),
      (3.9<.<4.0, true),
      (3.9<.<4.1, true),
      (3.9<.<5.0, true),
      
      (4.0<.<4.0, false),
      (4.0<.<4.1, false),
      (4.0<.<5.0, false),
      
      (4.1<.<4.1, false),
      (4.1<.<5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_Range_Int() {
    let cases:[(Range<Int>, Bool)] = [
      (10..<15, false),
      (10..<20, false),
      (10..<21, false),
      (10..<30, true),
      (10..<39, true),
      (10..<40, true),
      (10..<41, true),
      (10..<50, true),
      
      (19..<20, false),
      (19..<21, false),
      (19..<30, true),
      (19..<39, true),
      (19..<40, true),
      (19..<41, true),
      (19..<50, true),
      
      (20..<20, false),
      (20..<21, false),
      (20..<30, true),
      (20..<39, true),
      (20..<40, true),
      (20..<41, true),
      (20..<50, true),
      
      (30..<30, false),
      (30..<39, true),
      (30..<40, true),
      (30..<41, true),
      (30..<50, true),
      
      (39..<39, false),
      (39..<40, true),
      (39..<41, true),
      (39..<50, true),
      
      (40..<40, false),
      (40..<41, true),
      (40..<50, true),
      
      (41..<41, false),
      (41..<50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_LeftOpenRange_Range_Double() {
    let cases:[(Range<Double>, Bool)] = [
      (1.0..<1.5, false),
      (1.0..<2.0, false),
      (1.0..<2.1, true),
      (1.0..<3.0, true),
      (1.0..<3.9, true),
      (1.0..<4.0, true),
      (1.0..<4.1, true),
      (1.0..<5.0, true),
      
      (1.9..<2.0, false),
      (1.9..<2.1, true),
      (1.9..<3.0, true),
      (1.9..<3.9, true),
      (1.9..<4.0, true),
      (1.9..<4.1, true),
      (1.9..<5.0, true),
      
      (2.0..<2.0, false),
      (2.0..<2.1, true),
      (2.0..<3.0, true),
      (2.0..<3.9, true),
      (2.0..<4.0, true),
      (2.0..<4.1, true),
      (2.0..<5.0, true),
      
      (3.0..<3.0, false),
      (3.0..<3.9, true),
      (3.0..<4.0, true),
      (3.0..<4.1, true),
      (3.0..<5.0, true),
      
      (3.9..<3.9, false),
      (3.9..<4.0, true),
      (3.9..<4.1, true),
      (3.9..<5.0, true),
      
      (4.0..<4.0, false),
      (4.0..<4.1, true),
      (4.0..<5.0, true),
      
      (4.1..<4.1, false),
      (4.1..<5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(leftOpenRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(leftOpenRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_ClosedRange_Int() {
    let cases:[(ClosedRange<Int>, Bool)] = [
      (10...15, false),
      (10...20, false),
      (10...21, true),
      (10...30, true),
      (10...39, true),
      (10...40, true),
      (10...41, true),
      (10...50, true),
      
      (19...20, false),
      (19...21, true),
      (19...30, true),
      (19...39, true),
      (19...40, true),
      (19...41, true),
      (19...50, true),
      
      (20...20, false),
      (20...21, true),
      (20...30, true),
      (20...39, true),
      (20...40, true),
      (20...41, true),
      (20...50, true),
      
      (30...30, true),
      (30...39, true),
      (30...40, true),
      (30...41, true),
      (30...50, true),
      
      (39...39, true),
      (39...40, true),
      (39...41, true),
      (39...50, true),
      
      (40...40, false),
      (40...41, false),
      (40...50, false),
      
      (41...41, false),
      (41...50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_ClosedRange_Double() {
    let cases:[(ClosedRange<Double>, Bool)] = [
      (1.0...1.5, false),
      (1.0...2.0, false),
      (1.0...2.1, true),
      (1.0...3.0, true),
      (1.0...3.9, true),
      (1.0...4.0, true),
      (1.0...4.1, true),
      (1.0...5.0, true),
      
      (1.9...2.0, false),
      (1.9...2.1, true),
      (1.9...3.0, true),
      (1.9...3.9, true),
      (1.9...4.0, true),
      (1.9...4.1, true),
      (1.9...5.0, true),
      
      (2.0...2.0, false),
      (2.0...2.1, true),
      (2.0...3.0, true),
      (2.0...3.9, true),
      (2.0...4.0, true),
      (2.0...4.1, true),
      (2.0...5.0, true),
      
      (3.0...3.0, true),
      (3.0...3.9, true),
      (3.0...4.0, true),
      (3.0...4.1, true),
      (3.0...5.0, true),
      
      (3.9...3.9, true),
      (3.9...4.0, true),
      (3.9...4.1, true),
      (3.9...5.0, true),
      
      (4.0...4.0, false),
      (4.0...4.1, false),
      (4.0...5.0, false),
      
      (4.1...4.1, false),
      (4.1...5.0, false),
      ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_OpenRange_Int() {
    let cases:[(OpenRange<Int>, Bool)] = [
      (10<.<15, false),
      (10<.<20, false),
      (10<.<21, false),
      (10<.<30, true),
      (10<.<39, true),
      (10<.<40, true),
      (10<.<41, true),
      (10<.<50, true),
      
      (19<.<20, false),
      (19<.<21, false),
      (19<.<30, true),
      (19<.<39, true),
      (19<.<40, true),
      (19<.<41, true),
      (19<.<50, true),
      
      (20<.<20, false),
      (20<.<21, false),
      (20<.<30, true),
      (20<.<39, true),
      (20<.<40, true),
      (20<.<41, true),
      (20<.<50, true),
      
      (30<.<30, false),
      (30<.<39, true),
      (30<.<40, true),
      (30<.<41, true),
      (30<.<50, true),
      
      (39<.<39, false),
      (39<.<40, false),
      (39<.<41, false),
      (39<.<50, false),
      
      (40<.<40, false),
      (40<.<41, false),
      (40<.<50, false),
      
      (41<.<41, false),
      (41<.<50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_OpenRange_Double() {
    let cases:[(OpenRange<Double>, Bool)] = [
      (1.0<.<1.5, false),
      (1.0<.<2.0, false),
      (1.0<.<2.1, true),
      (1.0<.<3.0, true),
      (1.0<.<3.9, true),
      (1.0<.<4.0, true),
      (1.0<.<4.1, true),
      (1.0<.<5.0, true),
      
      (1.9<.<2.0, false),
      (1.9<.<2.1, true),
      (1.9<.<3.0, true),
      (1.9<.<3.9, true),
      (1.9<.<4.0, true),
      (1.9<.<4.1, true),
      (1.9<.<5.0, true),
      
      (2.0<.<2.0, false),
      (2.0<.<2.1, true),
      (2.0<.<3.0, true),
      (2.0<.<3.9, true),
      (2.0<.<4.0, true),
      (2.0<.<4.1, true),
      (2.0<.<5.0, true),
      
      (3.0<.<3.0, false),
      (3.0<.<3.9, true),
      (3.0<.<4.0, true),
      (3.0<.<4.1, true),
      (3.0<.<5.0, true),
      
      (3.9<.<3.9, false),
      (3.9<.<4.0, true),
      (3.9<.<4.1, true),
      (3.9<.<5.0, true),
      
      (4.0<.<4.0, false),
      (4.0<.<4.1, false),
      (4.0<.<5.0, false),
      
      (4.1<.<4.1, false),
      (4.1<.<5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_PartialRangeFrom_Int() {
    let cases:[(PartialRangeFrom<Int>, Bool)] = [
      (10..., true),
      (19..., true),
      (20..., true),
      (30..., true),
      (39..., true),
      (40..., false),
      (41..., false),
      ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_PartialRangeFrom_Double() {
    let cases:[(PartialRangeFrom<Double>, Bool)] = [
      (1.0..., true),
      (1.9..., true),
      (2.0..., true),
      (3.0..., true),
      (3.9..., true),
      (4.0..., false),
      (4.1..., false),
      ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_PartialRangeGreaterThan_Int() {
    let cases:[(PartialRangeGreaterThan<Int>, Bool)] = [
      (10<.., true),
      (19<.., true),
      (20<.., true),
      (30<.., true),
      (39<.., false),
      (40<.., false),
      (41<.., false),
      ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_PartialRangeGreaterThan_Double() {
    let cases:[(PartialRangeGreaterThan<Double>, Bool)] = [
      (1.0<.., true),
      (1.9<.., true),
      (2.0<.., true),
      (3.0<.., true),
      (3.9<.., true),
      (4.0<.., false),
      (4.1<.., false),
      ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_Range_Int() {
    let cases:[(Range<Int>, Bool)] = [
      (10..<15, false),
      (10..<20, false),
      (10..<21, false),
      (10..<30, true),
      (10..<39, true),
      (10..<40, true),
      (10..<41, true),
      (10..<50, true),
      
      (19..<20, false),
      (19..<21, false),
      (19..<30, true),
      (19..<39, true),
      (19..<40, true),
      (19..<41, true),
      (19..<50, true),
      
      (20..<20, false),
      (20..<21, false),
      (20..<30, true),
      (20..<39, true),
      (20..<40, true),
      (20..<41, true),
      (20..<50, true),
      
      (30..<30, false),
      (30..<39, true),
      (30..<40, true),
      (30..<41, true),
      (30..<50, true),
      
      (39..<39, false),
      (39..<40, true),
      (39..<41, true),
      (39..<50, true),
      
      (40..<40, false),
      (40..<41, false),
      (40..<50, false),
      
      (41..<41, false),
      (41..<50, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Int.overlaps(range), expected, message)
    }
  }
  
  func test_OpenRange_Range_Double() {
    let cases:[(Range<Double>, Bool)] = [
      (1.0..<1.5, false),
      (1.0..<2.0, false),
      (1.0..<2.1, true),
      (1.0..<3.0, true),
      (1.0..<3.9, true),
      (1.0..<4.0, true),
      (1.0..<4.1, true),
      (1.0..<5.0, true),
      
      (1.9..<2.0, false),
      (1.9..<2.1, true),
      (1.9..<3.0, true),
      (1.9..<3.9, true),
      (1.9..<4.0, true),
      (1.9..<4.1, true),
      (1.9..<5.0, true),
      
      (2.0..<2.0, false),
      (2.0..<2.1, true),
      (2.0..<3.0, true),
      (2.0..<3.9, true),
      (2.0..<4.0, true),
      (2.0..<4.1, true),
      (2.0..<5.0, true),
      
      (3.0..<3.0, false),
      (3.0..<3.9, true),
      (3.0..<4.0, true),
      (3.0..<4.1, true),
      (3.0..<5.0, true),
      
      (3.9..<3.9, false),
      (3.9..<4.0, true),
      (3.9..<4.1, true),
      (3.9..<5.0, true),
      
      (4.0..<4.0, false),
      (4.0..<4.1, false),
      (4.0..<5.0, false),
      
      (4.1..<4.1, false),
      (4.1..<5.0, false),
    ]
    
    for (range, expected) in cases {
      let message = "\(openRange_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(openRange_Double.overlaps(range), expected, message)
    }
  }
  
  func test_PartialRangeGreaterThan_ClosedRange_Int() {
    let cases:[(ClosedRange<Int>, Bool)] = [
      (10...15, false),
      (10...20, false),
      (10...21, true),
      (10...30, true),
      (10...39, true),
      (10...40, true),
      (10...41, true),
      (10...50, true),
      
      (19...20, false),
      (19...21, true),
      (19...30, true),
      (19...39, true),
      (19...40, true),
      (19...41, true),
      (19...50, true),
      
      (20...20, false),
      (20...21, true),
      (20...30, true),
      (20...39, true),
      (20...40, true),
      (20...41, true),
      (20...50, true),
      
      (30...30, true),
      (30...39, true),
      (30...40, true),
      (30...41, true),
      (30...50, true),
      
      (39...39, true),
      (39...40, true),
      (39...41, true),
      (39...50, true),
      
      (40...40, true),
      (40...41, true),
      (40...50, true),
      
      (41...41, true),
      (41...50, true),
    ]
    
    for (range, expected) in cases {
      let message = "\(partialRangeGreaterThan_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(partialRangeGreaterThan_Int.overlaps(range), expected, message)
    }
  }
  
  func test_PartialRangeGreaterThan_ClosedRange_Double() {
    let cases:[(ClosedRange<Double>, Bool)] = [
      (1.0...1.5, false),
      (1.0...2.0, false),
      (1.0...2.1, true),
      (1.0...3.0, true),
      (1.0...3.9, true),
      (1.0...4.0, true),
      (1.0...4.1, true),
      (1.0...5.0, true),
      
      (1.9...2.0, false),
      (1.9...2.1, true),
      (1.9...3.0, true),
      (1.9...3.9, true),
      (1.9...4.0, true),
      (1.9...4.1, true),
      (1.9...5.0, true),
      
      (2.0...2.0, false),
      (2.0...2.1, true),
      (2.0...3.0, true),
      (2.0...3.9, true),
      (2.0...4.0, true),
      (2.0...4.1, true),
      (2.0...5.0, true),
      
      (3.0...3.0, true),
      (3.0...3.9, true),
      (3.0...4.0, true),
      (3.0...4.1, true),
      (3.0...5.0, true),
      
      (3.9...3.9, true),
      (3.9...4.0, true),
      (3.9...4.1, true),
      (3.9...5.0, true),
      
      (4.0...4.0, true),
      (4.0...4.1, true),
      (4.0...5.0, true),
      
      (4.1...4.1, true),
      (4.1...5.0, true),
    ]
    
    for (range, expected) in cases {
      let message = "\(partialRangeGreaterThan_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(partialRangeGreaterThan_Double.overlaps(range), expected, message)
    }
  }
  
  func test_PartialRangeGreaterThan_Range_Int() {
    let cases:[(Range<Int>, Bool)] = [
      (10..<15, false),
      (10..<20, false),
      (10..<21, false),
      (10..<30, true),
      (10..<39, true),
      (10..<40, true),
      (10..<41, true),
      (10..<50, true),
      
      (19..<20, false),
      (19..<21, false),
      (19..<30, true),
      (19..<39, true),
      (19..<40, true),
      (19..<41, true),
      (19..<50, true),
      
      (20..<20, false),
      (20..<21, false),
      (20..<30, true),
      (20..<39, true),
      (20..<40, true),
      (20..<41, true),
      (20..<50, true),
      
      (30..<30, false),
      (30..<39, true),
      (30..<40, true),
      (30..<41, true),
      (30..<50, true),
      
      (39..<39, false),
      (39..<40, true),
      (39..<41, true),
      (39..<50, true),
      
      (40..<40, false),
      (40..<41, true),
      (40..<50, true),
      
      (41..<41, false),
      (41..<50, true),
      ]
    
    for (range, expected) in cases {
      let message = "\(partialRangeGreaterThan_Int) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(partialRangeGreaterThan_Int.overlaps(range), expected, message)
    }
  }
  
  func test_PartialRangeGreaterThan_Range_Double() {
    let cases:[(Range<Double>, Bool)] = [
      (1.0..<1.5, false),
      (1.0..<2.0, false),
      (1.0..<2.1, true),
      (1.0..<3.0, true),
      (1.0..<3.9, true),
      (1.0..<4.0, true),
      (1.0..<4.1, true),
      (1.0..<5.0, true),
      
      (1.9..<2.0, false),
      (1.9..<2.1, true),
      (1.9..<3.0, true),
      (1.9..<3.9, true),
      (1.9..<4.0, true),
      (1.9..<4.1, true),
      (1.9..<5.0, true),
      
      (2.0..<2.0, false),
      (2.0..<2.1, true),
      (2.0..<3.0, true),
      (2.0..<3.9, true),
      (2.0..<4.0, true),
      (2.0..<4.1, true),
      (2.0..<5.0, true),
      
      (3.0..<3.0, false),
      (3.0..<3.9, true),
      (3.0..<4.0, true),
      (3.0..<4.1, true),
      (3.0..<5.0, true),
      
      (3.9..<3.9, false),
      (3.9..<4.0, true),
      (3.9..<4.1, true),
      (3.9..<5.0, true),
      
      (4.0..<4.0, false),
      (4.0..<4.1, true),
      (4.0..<5.0, true),
      
      (4.1..<4.1, false),
      (4.1..<5.0, true),
    ]
    
    for (range, expected) in cases {
      let message = "\(partialRangeGreaterThan_Double) vs \(range): Overlaps?: `\(expected)` is expected."
      XCTAssertEqual(partialRangeGreaterThan_Double.overlaps(range), expected, message)
    }
  }
  
  static var allTests = [
    ("test_LeftOpenRange_ClosedRange_Int", test_LeftOpenRange_ClosedRange_Int),
    ("test_LeftOpenRange_ClosedRange_Double", test_LeftOpenRange_ClosedRange_Double),
    ("test_LeftOpenRange_LeftOpenRange_Int", test_LeftOpenRange_LeftOpenRange_Int),
    ("test_LeftOpenRange_LeftOpenRange_Double", test_LeftOpenRange_LeftOpenRange_Double),
    ("test_LeftOpenRange_OpenRange_Int", test_LeftOpenRange_OpenRange_Int),
    ("test_LeftOpenRange_OpenRange_Double", test_LeftOpenRange_OpenRange_Double),
    ("test_LeftOpenRange_PartialRangeFrom_Int", test_LeftOpenRange_PartialRangeFrom_Int),
    ("test_LeftOpenRange_PartialRangeFrom_Double", test_LeftOpenRange_PartialRangeFrom_Double),
    ("test_LeftOpenRange_PartialRangeGreaterThan_Int", test_LeftOpenRange_PartialRangeGreaterThan_Int),
    ("test_LeftOpenRange_PartialRangeGreaterThan_Double", test_LeftOpenRange_PartialRangeGreaterThan_Double),
    ("test_LeftOpenRange_Range_Int", test_LeftOpenRange_Range_Int),
    ("test_LeftOpenRange_Range_Double", test_LeftOpenRange_Range_Double),
    ("test_OpenRange_ClosedRange_Int", test_OpenRange_ClosedRange_Int),
    ("test_OpenRange_ClosedRange_Double", test_OpenRange_ClosedRange_Double),
    ("test_OpenRange_OpenRange_Int", test_OpenRange_OpenRange_Int),
    ("test_OpenRange_OpenRange_Double", test_OpenRange_OpenRange_Double),
    ("test_OpenRange_PartialRangeFrom_Int", test_OpenRange_PartialRangeFrom_Int),
    ("test_OpenRange_PartialRangeFrom_Double", test_OpenRange_PartialRangeFrom_Double),
    ("test_OpenRange_PartialRangeGreaterThan_Int", test_OpenRange_PartialRangeGreaterThan_Int),
    ("test_OpenRange_PartialRangeGreaterThan_Double", test_OpenRange_PartialRangeGreaterThan_Double),
    ("test_OpenRange_Range_Int", test_OpenRange_Range_Int),
    ("test_OpenRange_Range_Double", test_OpenRange_Range_Double),
    ("test_PartialRangeGreaterThan_ClosedRange_Int", test_PartialRangeGreaterThan_ClosedRange_Int),
    ("test_PartialRangeGreaterThan_ClosedRange_Double", test_PartialRangeGreaterThan_ClosedRange_Double),
    ("test_PartialRangeGreaterThan_Range_Int", test_PartialRangeGreaterThan_Range_Int),
    ("test_PartialRangeGreaterThan_Range_Double", test_PartialRangeGreaterThan_Range_Double),
  ]
}

