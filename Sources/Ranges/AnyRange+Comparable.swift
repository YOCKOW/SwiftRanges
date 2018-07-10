/***************************************************************************************************
 AnyRange+Comparable.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation

private enum WhichBound {
  case lower, upper
}

extension AnyRange.BoundRepresentation {
  fileprivate func _compare(_ other:AnyRange.BoundRepresentation, as bound:WhichBound) -> ComparisonResult {
    if self.bound < other.bound { return .orderedAscending }
    if self.bound > other.bound { return .orderedDescending }
    
    // from here, self.bound == other.bound
    if self.isIncluded == other.isIncluded { return .orderedSame }
    if self.isIncluded {
      // other is not included
      return bound == .lower ? .orderedAscending : .orderedDescending
    }
    return bound == .lower ? .orderedDescending : .orderedAscending
  }
}

extension AnyRange {
  /// Compare two ranges.
  ///
  /// ## Comparison Rules for AnyRange:
  /// 1. First, compare lower bounds. Next, compare upper bounds if the lower bounds are equal.
  /// 2. Unbounded Range < [others] < Empty Range
  /// 3. Regard `PartialRange(From|GreaterThan)`'s upper bound as +∞.
  /// 4. Regard `PartialRange(Through|UpTo)`'s lower bound as -∞.
  public func compare(_ other:AnyRange<Bound>) -> ComparisonResult {
    if self == other { return .orderedSame }
    
    // from here, lhs is not equal to rhs.
    
    guard let boundsL = self.bounds else {
      // if lhs represents empty...
      return .orderedDescending
    }
    guard let boundsR = other.bounds else {
      // if rhs represents empty...
      return .orderedAscending
    }
    
    if boundsL.lower == nil && boundsL.upper == nil {
      // lhs represents unbounded...
      if boundsR.lower == nil && boundsR.upper == nil {
        // rhs also represents unbounded...
        return .orderedSame
      }
      return .orderedAscending
    }
    
    let compare: (BoundRepresentation?, BoundRepresentation?, WhichBound) -> ComparisonResult = {
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
    
    let lowerResult = compare(boundsL.lower, boundsR.lower, .lower)
    if lowerResult != .orderedSame {
      return lowerResult
    }
    
    return compare(boundsL.upper, boundsR.upper, .upper)
  }
}

extension AnyRange: Comparable {
  public static func <(lhs: AnyRange<Bound>, rhs: AnyRange<Bound>) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
  }
}
