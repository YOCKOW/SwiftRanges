/***************************************************************************************************
 GeneralizedRange+Comparison.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation
 
extension GeneralizedRange {
  /// Compare two ranges.
  /// This function is declared as public, but it is intended to be used internally.
  ///
  /// ## Comparison Rules for GeneralizedRange:
  /// 1. Unbounded Range < [others] < Empty Range
  /// 2. (If they are not unbounded nor empty,)
  ///    First, compare their lower bounds.
  ///    Next, compare their upper bounds if the lower bounds are equal.
  /// 3. Regard `PartialRange(From|GreaterThan)`'s upper bound as +∞.
  /// 4. Regard `PartialRange(Through|UpTo)`'s lower bound as -∞.
  public func compare<T>(_ other:T) -> ComparisonResult
    where T:GeneralizedRange, T.Bound == Self.Bound
  {
    let myNilableBounds = self.bounds
    let otherNilableBounds = other.bounds
    
    // If one of them is empty...
    switch (myNilableBounds, otherNilableBounds) {
    case (nil, nil):
      return .orderedSame
    case (nil, _):
      return .orderedDescending
    case (_, nil):
      return .orderedAscending
    default:
      break
    }
    
    let myBounds = myNilableBounds!
    let otherBounds = otherNilableBounds!
    
    // If one of them is unbounded...
    switch (myBounds.lower, myBounds.upper, otherBounds.lower, otherBounds.upper) {
    case (nil, nil, nil, nil):
      // both are unbounded
      return .orderedSame
    case (nil, nil, _, _):
      return .orderedAscending
    case (_, _, nil, nil):
      return .orderedDescending
    default:
      break
    }
    
    // From here, self and other are not empty nor unbounded
    
    let compare: (Boundary<Bound>?, Boundary<Bound>?, Boundary<Bound>._Side) -> ComparisonResult = {
      switch ($0, $1) {
      case (nil, nil):
        return .orderedSame
      case (nil, _):
        return $2 == .lower ? .orderedAscending : .orderedDescending
      case (_, nil):
        return $2 == .lower ? .orderedDescending : .orderedAscending
      case (let ll?, let rr?):
        return ll._compare(rr, as:$2)
      }
    }
    
    let lowerComparison  = compare(myBounds.lower, otherBounds.lower, .lower)
    if lowerComparison != .orderedSame { return lowerComparison }
    return compare(myBounds.upper, otherBounds.upper, .upper)
  }
  
}

extension GeneralizedRange {
  public static func ==<T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return lhs.compare(rhs) == .orderedSame
  }
  
  public static func < <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return lhs.compare(rhs) == .orderedAscending
  }
  
  
  public static func >= <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return !(lhs < rhs)
  }
  
  public static func > <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return lhs.compare(rhs) == .orderedDescending
  }
  
  public static func <= <T>(lhs:Self, rhs:T) -> Bool where T:GeneralizedRange, T.Bound == Self.Bound {
    return !(lhs < rhs)
  }
}
