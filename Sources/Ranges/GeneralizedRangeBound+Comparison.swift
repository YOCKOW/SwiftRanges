/***************************************************************************************************
 GeneralizedRangeBound+Comparison.swift
   © 2018-2019,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 **************************************************************************************************/

import Foundation

extension GeneralizedRangeBound {
  internal enum _Side {
    case lower, upper
  }
}

extension GeneralizedRangeBound {
  internal func _compare(_ other: GeneralizedRangeBound<Value>, side: _Side) -> ComparisonResult {
    if self == other { return .orderedSame }
    
    // from here, self != other
    if self == .unbounded {
      return side == .lower ? .orderedAscending : .orderedDescending
    } else if other == .unbounded {
      return side == .lower ? .orderedDescending : .orderedAscending
    }
    
    // from here, both self and other are not .unbounded
    let myValue = self.value!
    let otherValue = other.value!
    
    if myValue < otherValue { return .orderedAscending }
    if myValue > otherValue { return .orderedDescending }
    
    // from here, they have the same values
    if case .included = self {
      // other is not included
      return side == .lower ? .orderedAscending : .orderedDescending
    }
    return side == .lower ? .orderedDescending : .orderedAscending
  }
  
  internal func _compare(_ value: Value, side: _Side) -> ComparisonResult {
    switch (self, side) {
    case (.unbounded, .lower):
      return .orderedAscending
    case (.unbounded, .upper):
      return .orderedDescending
    case (.included(let myValue), _):
      if myValue < value { return .orderedAscending }
      if myValue == value { return .orderedSame }
      return .orderedDescending
    case (.excluded(let myValue), .lower):
      if myValue < value { return .orderedAscending }
      return .orderedDescending
    case (.excluded(let myValue), .upper):
      if myValue <= value { return .orderedAscending }
      return .orderedDescending
    }
  }
}

internal func _max<Bound>(
  _ firstBound: GeneralizedRangeBound<Bound>,
  _ otherBounds: GeneralizedRangeBound<Bound>...,
  side: GeneralizedRangeBound<Bound>._Side
) -> GeneralizedRangeBound<Bound> where Bound: Comparable {
  var max: GeneralizedRangeBound<Bound> = firstBound
  for boundary in otherBounds {
    if boundary == .unbounded && side == .upper { return .unbounded }
    if max._compare(boundary, side: side) == .orderedAscending { max = boundary }
  }
  return max
}

internal func _min<Bound>(
  _ firstBounds: GeneralizedRangeBound<Bound>,
  _ otherBounds: GeneralizedRangeBound<Bound>...,
  side:GeneralizedRangeBound<Bound>._Side
) -> GeneralizedRangeBound<Bound> where Bound: Comparable {
  var min: GeneralizedRangeBound<Bound> = firstBounds
  for boundary in otherBounds {
    if boundary == .unbounded && side == .lower { return .unbounded }
    if min._compare(boundary, side: side) == .orderedDescending { min = boundary }
  }
  return min
}


