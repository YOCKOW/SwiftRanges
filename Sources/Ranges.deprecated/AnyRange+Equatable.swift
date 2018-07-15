/***************************************************************************************************
 AnyRange+Equatable.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

extension PartialRangeFrom: Equatable {
  public static func ==(lhs: PartialRangeFrom<Bound>, rhs: PartialRangeFrom<Bound>) -> Bool {
    return lhs.lowerBound == rhs.lowerBound
  }
}

extension PartialRangeThrough: Equatable {
  public static func ==(lhs: PartialRangeThrough<Bound>, rhs: PartialRangeThrough<Bound>) -> Bool {
    return lhs.upperBound == rhs.upperBound
  }
}

extension PartialRangeUpTo: Equatable {
  public static func ==(lhs: PartialRangeUpTo<Bound>, rhs: PartialRangeUpTo<Bound>) -> Bool {
    return lhs.upperBound == rhs.upperBound
  }
}

extension AnyRange: Equatable {
  public static func ==(lhs: AnyRange<Bound>, rhs: AnyRange<Bound>) -> Bool {
    switch (lhs._range, rhs._range) {
    case (.empty, .empty):
      return true
    case (.unboundedRange, .unboundedRange):
      return true
      
    case (.closedRange(let ll), .closedRange(let rr)):
      return ll == rr
    case (.leftOpenRange(let ll), .leftOpenRange(let rr)):
      return ll == rr
    case (.openRange(let ll), .openRange(let rr)):
      return ll == rr
    case (.range(let ll), .range(let rr)):
      return ll == rr
      
    case (.partialRangeFrom(let ll), .partialRangeFrom(let rr)):
      return ll == rr
    case (.partialRangeGreaterThan(let ll), .partialRangeGreaterThan(let rr)):
      return ll == rr
    case (.partialRangeThrough(let ll), .partialRangeThrough(let rr)):
      return ll == rr
    case (.partialRangeUpTo(let ll), .partialRangeUpTo(let rr)):
      return ll == rr
      
    default:
      return false
    }
  }
}
